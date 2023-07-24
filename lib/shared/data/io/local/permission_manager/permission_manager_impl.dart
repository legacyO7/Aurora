import 'dart:io';

import 'package:aurora/shared/shared.dart';

import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';


class PermissionManagerImpl implements PermissionManager{
  
  PermissionManagerImpl(this._terminalDelegate,this._serviceManager, this._ioManager);
  
  final TerminalRepo _terminalDelegate;
  final ServiceManager _serviceManager;
  final IOManager _ioManager;

  final List<String> _checkInstalledPackages=['dkms', 'openssl','mokutil','git','make','cmake'];

  List<String> _deniedList=[];
  List<String> missingPackages=[];

  @override
  Future<int> runWithPrivileges(List<String> commands) async{
    return await _terminalDelegate.getStatusCode("${Constants.kPolkit} sh -c '${commands.join('; ')}'");
  }

  @override
  Future<int> setPermissions() async{
    List<String> commands=[];
    if(_deniedList.isNotEmpty){
      commands.add("chmod -R o+rwx ${_deniedList.join(' ')}");
    }

    if(await _ioManager.checkIfExists(filePath: Constants.kServicePath+Constants.kServiceName, fileType: FileSystemEntityType.file)){
      commands.add("systemctl disable ${Constants.kServiceName}");
    }else{
      await _serviceManager.createService();
    }
    commands.add("systemctl enable ${Constants.kServiceName}");

    var statusCode= await runWithPrivileges(commands);

    if(await checkPermissions(paths: _deniedList)) {
      await _doPostPermission();
    }

    return statusCode;
  }

  Future _doPostPermission() async{
    if(_checkIfOldServiceExists()){
     await File(Constants.kOldServicePath+Constants.kServiceName).delete();
    }
  }

  Future<bool> checkPermissions({List<String> paths=const []}) async {
    _deniedList=[];
    if(paths.isNotEmpty) {
      for (var file in paths) {
        if (!(await _ioManager.getFileStat(file)).endsWith('rwx')) {
          _deniedList.add(file);
        }
      }
    }

    return _deniedList.isEmpty;
  }

  bool _checkIfOldServiceExists()=> (File(Constants.kOldServicePath+Constants.kServiceName).existsSync());

  @override
  Future<bool> validatePaths() async{

    GlobalConfig globalConfig=Constants.globalConfig;

    List<String> pathList=[Constants.kServicePath];
    pathList.add(Constants.kServicePath+Constants.kServiceName);

    if(_checkIfOldServiceExists()){
      pathList.add(Constants.kOldServicePath+Constants.kServiceName);
    }

    if(globalConfig.arMode.name.contains(ArModeEnum.mainline.name)){
      pathList.addAll([
        Constants.kMainlineModuleStatePath,
        Constants.kMainlineModuleModePath,
        Constants.kMainlineBrightnessPath
      ]);
    }

    if(globalConfig.kThresholdPath!=null){
      pathList.add(globalConfig.kThresholdPath!);
    }
    
    if (globalConfig.arMode==ArModeEnum.faustus) {
      pathList.addAll([
        Constants.kFaustusModuleBrightnessPath,
        Constants.kFaustusModuleRedPath,
        Constants.kFaustusModuleGreenPath,
        Constants.kFaustusModuleBluePath,
        Constants.kFaustusModuleSpeedPath,
        Constants.kFaustusModuleModePath,
        Constants.kFaustusModuleFlagsPath,
        Constants.kFaustusModuleSetPath
      ]);
    }

    if(await File("${Constants.globalConfig.kTmpPath}/ar.log").exists()){
      pathList.add("${Constants.globalConfig.kTmpPath}/ar.log");
    }

    if(await File("${Constants.globalConfig.kWorkingDirectory}").exists()){
      pathList.add("${Constants.globalConfig.kWorkingDirectory}");
    }

    return await checkPermissions(paths: pathList);
  }

  @override
  Future<List<String>> listPackagesToInstall() async{
    for(var package in _checkInstalledPackages) {
      if((await _terminalDelegate.getOutput("command -v $package")).isEmpty){
        missingPackages.add(package);
      }
    }
    return missingPackages;
  }


  @override
  List<String> get listMissingPackages=>missingPackages;

  @override
  List<String> get deniedList=>_deniedList;


}