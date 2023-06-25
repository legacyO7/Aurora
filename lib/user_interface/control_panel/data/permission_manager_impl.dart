import 'dart:io';

import 'package:aurora/user_interface/control_panel/data/permission_manager.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';

class PermissionManagerImpl implements PermissionManager{
  
  PermissionManagerImpl(this._terminalDelegate);
  
  final TerminalDelegate _terminalDelegate;
  final List<String> _checkInstalledPackages=['dkms', 'openssl','mokutil','git','make','cmake'];

  List<String> _deniedList=[];
  List<String> missingPackages=[];

  @override
  Future setPermissions() async{
    await _terminalDelegate.execute("${Constants.kPolkit} chmod -R o+rwx ${_deniedList.join(' ')}");
  }

  checkPermissions({List<String> paths=const []}) {
    _deniedList=[];
    if(paths.isNotEmpty) {
      for (var file in paths) {
        if (!File(file).statSync().modeString().endsWith('rwx')) {
          _deniedList.add(file);
        }
      }
    }
  }

  @override
  Future<bool> validatePaths() async{

    GlobalConfig globalConfig=Constants.globalConfig;

    List<String> pathList=[];
    if(globalConfig.arMode.name.contains(ARMODE.mainline.name)){
      pathList.addAll([
        Constants.kMainlineModuleStatePath,
        Constants.kMainlineModuleModePath,
        Constants.kMainlineBrightnessPath
      ]);

      if(globalConfig.kThresholdPath!=null){
        pathList.add(globalConfig.kThresholdPath!);
      }

    }

    if (globalConfig.arMode==ARMODE.batteryManager&&globalConfig.kThresholdPath!=null) {
      pathList.add(globalConfig.kThresholdPath!);
    }
    
    
    if (globalConfig.arMode==ARMODE.faustus) {
      pathList.addAll([
        Constants.kFaustusModuleBrightnessPath,
        Constants.kFaustusModuleRedPath,
        Constants.kFaustusModuleGreenPath,
        Constants.kFaustusModuleBluePath,
        Constants.kFaustusModuleSpeedPath,
        Constants.kFaustusModuleModePath,
        Constants.kFaustusModuleFlagsPath,
      ]);
    }
    
    
    
    await checkPermissions(paths: pathList);
    
    return _deniedList.isEmpty;

  }

  @override
  Future<List<String>> listPackagesToInstall() async{
    for(var package in _checkInstalledPackages) {
      if((await _terminalDelegate.getOutput(command: "command -v $package")).isEmpty){
        missingPackages.add(package);
      }
    }
    return missingPackages;
  }


  @override
  List<String> get listMissingPackages=>missingPackages;


}