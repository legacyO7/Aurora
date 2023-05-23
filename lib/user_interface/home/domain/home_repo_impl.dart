import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with GlobalMixin{

  HomeRepoImpl(this._terminalDelegate,this._prefRepo);

  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;

  final _globalConfig=Constants.globalConfig;

  @override
  List<String> readFile({required String path}){
    return (File(path).readAsLinesSync());
  }

  @override
  Future<bool> checkInternetAccess() async{
    try {
      final result = await InternetAddress.lookup('www.google.com');
        return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future launchArUrl({String? subPath}) async {
    var url = Uri.parse(Constants.kAuroraGitUrl+(subPath??''));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "error launching $url";
    }
  }

  @override
  Future<String> getVersion() async{
    var version= (await PackageInfo.fromPlatform()).version;
    _globalConfig.setInstance(
        arVersion:version,
        arChannel: version.split('-')[1]
    );
    return version;
  }

  @override
  void setAppHeight(){
    var window = WindowManager.instance;
    window..setMinimumSize(Size(1000,super.isMainLine()?680:600))
    ..show()
    ..focus();
  }

  Future<bool> _isDeviceCompatible() async{

    bool checkDeviceInfo({required String info}){
      return (info.toLowerCase().contains('asus'));
    }

    if(File(Constants.kProductName).existsSync()){
      Constants.globalConfig.setInstance(deviceName: File(Constants.kProductName).readAsLinesSync().toString());
      return checkDeviceInfo(info: Constants.globalConfig.deviceName);
    } else if(File(Constants.kVendorName).existsSync()){
      return checkDeviceInfo(info: File(Constants.kVendorName).readAsLinesSync().toString());
    }
    debugPrint("unknown device");
    return true;
  }

  @override
  Future<int> compatibilityChecker() async{

    if(!await _isDeviceCompatible()){
      return 7;
    }

    if(!await _terminalDelegate.pkexecChecker()){
      return 6;
    }

    if(isMainLineCompatible()){
      if(await _thresholdPathExists()){
        _globalConfig.setInstance(arMode: ARMODE.mainline);
      }else{
        _globalConfig.setInstance(arMode:  ARMODE.mainlineWithoutBatteryManager);
      }
      return 4;
    }

    if(!checkFaustusFolder()) {
      if(await _thresholdPathExists()) {
        return 3;
      } else {
        return 2;
      }
    }else if(await _terminalDelegate.isKernelCompatible()) {
      return 5;
    }

    if((await _terminalDelegate.listPackagesToInstall()).isNotEmpty) {
      return 1;
    }

    _globalConfig.setInstance(arMode: ARMODE.normal);
    return 0;
  }

  Future<bool> _thresholdPathExists() async{
    Directory powerDir=Directory(Constants.kPowerSupplyPath);
    String? thresholdPath;
    if(powerDir.existsSync()){

      await for(var file in powerDir.list()){
        if(file.path.split('/').last.contains('BAT')){
          thresholdPath='${file.path}/charge_control_end_threshold';
          break;
        }
      }

      if(thresholdPath!=null&&File(thresholdPath).existsSync()){
        _globalConfig.setInstance(kThresholdPath: thresholdPath);
      }
    }
    return _globalConfig.kThresholdPath!=null;
  }


  @override
  int convertVersionToInt(String version) {
    return int.tryParse(version.replaceAll('.', '').replaceAll('+', '').split('-')[0])??0;
  }

  @override
  bool checkFaustusFolder()=>Directory(Constants.kFaustusModulePath).existsSync();

  Future _getAccess() async{
    await _terminalDelegate.execute("${Constants.kPolkit} ${super.isMainLine()? _globalConfig.kExecMainlinePath: _globalConfig
        .kExecFaustusPath} init ${_globalConfig.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
  }

  Future<bool> _checkAccess() async{
    return await _terminalDelegate.checkAccess();
  }

  @override
  Future loadScripts() async{
    _globalConfig.kExecBatteryManagerPath= await _terminalDelegate.extractAsset(sourceFileName:Constants.kBatteryManager);
    if(super.isMainLine()){
      _globalConfig.kExecMainlinePath= await _terminalDelegate.extractAsset(sourceFileName: Constants.kMainline);
    }else {
      _globalConfig.kExecFaustusPath=await _terminalDelegate.extractAsset(sourceFileName: Constants.kFaustus);
    }
  }

  @override
  Future<bool> requestAccess() async{
    var checkAccess=await _checkAccess();
    if(!checkAccess) {
      await _getAccess();
      checkAccess=await _checkAccess();
    }
    return checkAccess;
  }

}