import 'dart:io';


import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with GlobalMixin, TerminalMixin{

  HomeRepoImpl(this._terminalRepo, this._permissionManager, this._ioManager, this._fileManager, this._isarDelegate, this._disableSettingsRepo);

  final TerminalRepo _terminalRepo;
  final PermissionManager _permissionManager;
  final IOManager _ioManager;
  final FileManager _fileManager;
  final IsarDelegate _isarDelegate;
  final DisableSettingsRepo _disableSettingsRepo;


  @override
  void setAppHeight(){
    var window = WindowManager.instance;
    window..setMinimumSize(Size(1000,super.isMainLine()?680:600))
    ..show()
    ..focus();
  }

  Future _getAccess() async{
     await _permissionManager.setPermissions();
  }

  @override
  Future<bool> canElevate() async{
    return await _ioManager.checkIfExists(filePath: Constants.kInstalledBinary, fileType: FileSystemEntityType.file) && isInstalledPackage();
  }

  @override
  Future selfElevate() async{
    if(await canElevate()) {
        await _terminalRepo.execute("${Constants.kInstalledBinary} --with-root");
        exit(0);
    }else{
      arSnackBar(text: "Can't elevate at this point",isPositive: false);
    }
  }

  Future<bool> _checkAccess() async{
    return await _permissionManager.validatePaths() &&( await super.arServiceEnabled() || !Constants.globalConfig.isBatteryManagerEnabled);
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


  @override
  Future<bool> enforcement(Enforcement enforce) async{
    bool isSuccess=false;
    if(enforce==Enforcement.faustus){
      isSuccess= await _disableSettingsRepo.disableServices(disable: DisableEnum.mainline);
    }
    if(enforce==Enforcement.mainline){
      isSuccess= await _disableSettingsRepo.disableServices(disable: DisableEnum.faustus);
    }

    if(isSuccess) {
      bool isFaustusEnforced=enforce==Enforcement.faustus;
      await _isarDelegate.setEnforceFaustus(isFaustusEnforced);
    }

    return isSuccess;
  }

  @override
  Future initLog() async{

    _fileManager.setWorkingDirectory();

   ArLogger.log(data: "Build Version          : ${await getVersion()}");
   ArLogger.log(data: "Build Type             : ${Constants.buildType.name}");
   ArLogger.log(data: "Compatible Device      : ${await _fileManager.isDeviceCompatible()}");
   ArLogger.log(data: "Compatible Kernel      : ${await super.isKernelCompatible()}");
   ArLogger.log(data: "Mainline Mode          : ${isMainLineCompatible()}");
   ArLogger.log(data: "System has systemd     : ${await systemHasSystemd()}");
   ArLogger.log(data: "Threshold Path Exists  : ${await _fileManager.thresholdPathExists()}");
   ArLogger.log(data: "Working Directory      : ${Constants.globalConfig.kWorkingDirectory}");

    if(await  _ioManager.checkIfExists(filePath: "${Constants.globalConfig.kTmpPath}/ar.log", fileType: FileSystemEntityType.file)) {
      await _terminalRepo.execute("chown \$(logname) ${Constants.globalConfig.kTmpPath}/ar.log");
    }

  }


}