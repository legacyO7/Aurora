import 'dart:io';


import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/services.dart';

class SetupRepoImpl extends SetupRepo with GlobalMixin, TerminalMixin{
  SetupRepoImpl(this._setupSource,this._terminalRepo,this._permissionManager,this._fileManager, this._isarDelegate);

  final SetupSource _setupSource;
  final TerminalRepo _terminalRepo;
  final PermissionManager _permissionManager;
  final FileManager _fileManager;
  final IsarDelegate _isarDelegate;

  final _globalConfig=Constants.globalConfig;
  String _setupPath='';
  String _terminalList = '';
  bool _pkexec=false;
  List<String> _blacklistedConfs=[];


  @override
  Future<String> getTerminalList()async{
    var output=await _setupSource.getTerminalList();
    if(output.isEmpty) return '';
    return output.split('"\$TERMINAL" ')[1].split(';')[0];
  }

  @override
  Future<String> getAuroraLiveVersion() async{
    var output=await _setupSource.getAuroraLiveVersion();
    if(output.isEmpty) return '0';
    return output.split('version: ')[1].split('+')[0];
  }

  @override
  Future<String> getChangelog() async{
    return await _setupSource.getChangelog();
  }
  
  @override
  Future initSetup() async{
    try {
      _fileManager.setWorkingDirectory();
      if (!isMainLineCompatible()) {
        _globalConfig.setInstance(
            kSecureBootEnabled: await super.isSecureBootEnabled()
        );
      }
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
    }
  }
  
  @override
  Future loadSetupFiles() async{
    await _fileManager.setTmpWorkingDir();
    await _extractAsset(sourceFileName: Constants.kFaustusInstaller);
    _setupPath = "${await _extractAsset(sourceFileName: Constants.kArSetup)} ${_globalConfig.kWorkingDirectory}";

    if(_globalConfig.kSecureBootEnabled! || !await super.pkexecChecker()){
      _terminalList = '" ${(await getTerminalList())} "';
    }
  }

  Future<String> _extractAsset({required String sourceFileName}) async {
    final byteData = await rootBundle.load('${Constants.kAssetsPath}/$sourceFileName');
    var destinationFileName = "${Constants.globalConfig.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await _terminalRepo.execute("chmod +x $destinationFileName");
    return destinationFileName;
  }
  
  @override
  Future installPackages() async{
    if (_terminalList.isNotEmpty || _pkexec) {
      await _terminalRepo.execute("${!_pkexec ? '' : Constants.kPolkit} $_setupPath installpackages $_terminalList");
    } else {
      arSnackBar(text: "Fetching Data Failed", isPositive: false);
    }
  }

  @override
  Future<bool> pkexecChecker() async{
    _pkexec= await super.pkexecChecker();
    return _pkexec;
  }

  @override
  Future<bool> checkInternetAccess() async{
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (e,stackTrace) {
      ArLogger.log(data: e,stackTrace: stackTrace);
      return false;
    }
  }


  @override
  Future<int> compatibilityChecker() async{

    if(!await _fileManager.isDeviceCompatible()){
      return 7;
    }

    if(!await super.pkexecChecker()){
      return 6;
    }

    if(isMainLineCompatible()){
      if(await _fileManager.thresholdPathExists() && await systemHasSystemd()){
        _globalConfig.setInstance(arMode: ArModeEnum.mainline);
      }else{
        _globalConfig.setInstance(arMode:  ArModeEnum.mainlineWithoutBatteryManager);
      }
      return 4;
    }

    if(await super.isKernelCompatible() && !await checkIfBlackListed() && !_globalConfig.isFaustusEnforced) {
      return 5;
    }

    if(!await checkFaustusFolder()) {
      if(await _fileManager.thresholdPathExists() && !_globalConfig.isFaustusEnforced && await systemHasSystemd()) {
        return 3;
      } else {
        return 2;
      }
    }

    if((await _permissionManager.listPackagesToInstall()).isNotEmpty) {
      return 1;
    }

    _globalConfig.setInstance(arMode: ArModeEnum.faustus);
    await  _fileManager.releaseTmpWorkingDir();
    return 0;
  }


  @override
  Future<bool> checkFaustusFolder() async=> await Directory(Constants.kFaustusModulePath).exists();


  @override
  int convertVersionToInt(String version) {
    return int.tryParse(version.replaceAll('.', '').replaceAll('+', '').split('-')[0])??0;
  }

  @override
  Future installFaustus() async{
    await _terminalRepo.execute("${_globalConfig.kSecureBootEnabled! ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.globalConfig.kFaustusGitUrl} $_terminalList");
  }

  @override
  List<String> get missingPackagesList => _permissionManager.listMissingPackages;


  @override
  Future<bool> isFaustusEnforced() async{
    return await _isarDelegate.getEnforceFaustus();
  }

  @override
  Future<bool> checkIfBlackListed() async{
    _blacklistedConfs= (await _fileManager.searchTextFilesInDirectory(
        searchText: kernelModules(ArModules.mainline),
        directoryPath: Constants.kBlacklistPath)
    );

    if(_blacklistedConfs.isNotEmpty){
      _blacklistedConfs.removeWhere((element) => element=='${Constants.kBlacklistPath}faustus.conf');
    }

    return _blacklistedConfs.isNotEmpty;
  }

  @override
  List<String> get blacklistedConfs  => _blacklistedConfs;

}