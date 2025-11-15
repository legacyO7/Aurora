import 'dart:io';



import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';


class PermissionManagerImpl implements PermissionManager{
  
  PermissionManagerImpl(this._terminalDelegate,this._serviceManager, this._ioManager);
  
  final TerminalRepo _terminalDelegate;
  final ServiceManager _serviceManager;
  final IOManager _ioManager;

  final List<String> _checkInstalledPackages=['dkms', 'openssl','mokutil','git','make','cmake'];

  final GlobalConfig _globalConfig=Constants.globalConfig;


  List<String> _deniedList=[];
  List<String> missingPackages=[];

  @override
  Future<int> runWithPrivileges(List<String> commands) async{
    return await _terminalDelegate.getStatusCode("${Constants.kPolkit} sh -c \"${commands.join(';\n')}\"".replaceAll("EOF;", 'EOF'));
  }

  @override
  Future<int> setPermissions() async{
    List<String> commands=[];
    if(_deniedList.isNotEmpty){
      commands.add("chmod -R o+rwx ${_deniedList.join(' ')}");
    }

    if(_globalConfig.isBatteryManagerEnabled || _globalConfig.isBacklightControllerServiceEnabled) {
      if (await _ioManager.checkIfExists(filePath: Constants.kServicePath + Constants.kServiceName, fileType: FileSystemEntityType.file)) {
        commands.add("systemctl disable ${Constants.kServiceName}");
      } else {
        if(await hasPermission(Constants.kServicePath)) {
          await _serviceManager.createService();
        }else{
          commands.insertAll(0, [
           await _serviceManager.createServiceContentByShell
          ]);
        }
      }
      commands.add("systemctl enable ${Constants.kServiceName}");
    }

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

  @override
  Future<bool> hasPermission(String path) async{
    return (await getPermission(path)).endsWith('rwx');
  }
  
  @override
  Future<String> getPermission(String path) async{
    return (await _ioManager.getFileStat(path));
  }

  Future<bool> checkPermissions({List<String> paths=const []}) async {
    _deniedList=[];
    if(paths.isNotEmpty) {
      for (var file in paths) {
        if (!await hasPermission(file)) {
          _deniedList.add(file);
        }
      }
    }

    return _deniedList.isEmpty;
  }

  bool _checkIfOldServiceExists()=> (File(Constants.kOldServicePath+Constants.kServiceName).existsSync());

  @override
  Future<bool> validatePaths() async{

    Set<String> pathList={};

    if(_checkIfOldServiceExists()){
      pathList.add(Constants.kOldServicePath+Constants.kServiceName);
    }

    if(_globalConfig.kThresholdPath!=null && _globalConfig.isBatteryManagerEnabled){
      pathList.add(Constants.kServicePath+Constants.kServiceName);
      pathList.add(_globalConfig.kThresholdPath!);
    }

    if(_globalConfig.isBacklightControllerServiceEnabled){
      pathList.add(Constants.kServicePath+Constants.kServiceName);
    }

    if(_globalConfig.isBacklightControllerEnabled) {
      if (_globalConfig.arMode.name.contains(ArModeEnum.mainline.name)) {
        pathList.addAll([
          Constants.kMainlineModuleStatePath,
          Constants.kMainlineModuleModePath,
          Constants.kMainlineBrightnessPath
        ]);
      }

      if (_globalConfig.arMode == ArModeEnum.faustus) {
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
    }

    if(await File("${Constants.globalConfig.kTmpPath}/ar.log").exists()){
      pathList.add("${Constants.globalConfig.kTmpPath}/ar.log");
    }

    if(await File("${Constants.globalConfig.kWorkingDirectory}").exists()){
      pathList.add("${Constants.globalConfig.kWorkingDirectory}");
    }

    return await checkPermissions(paths: pathList.toList());
  }

  @override
  Future<List<String>> listPackagesToInstall() async{
    missingPackages=[];
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