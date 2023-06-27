import 'dart:io';

import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/data/io/permission_manager/permission_manager.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with GlobalMixin{

  HomeRepoImpl(this._terminalDelegate, this._permissionManager, this._ioManager, this._arLogger);

  final TerminalDelegate _terminalDelegate;
  final PermissionManager _permissionManager;
  final IOManager _ioManager;
  final ArLogger _arLogger;

  final _globalConfig=Constants.globalConfig;


  @override
  Future writeToFile({required String path, required String content}) async{
    await _ioManager.writeToFile(filePath: path, content: content);
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

  @override
  Future<bool> isDeviceCompatible() async{

    bool checkDeviceInfo({required String info}){
      return (info.toLowerCase().contains('asus'));
    }

    if(File(Constants.kProductName).existsSync()){
      Constants.globalConfig.setInstance(deviceName: ( await _ioManager.readFile(Constants.kProductName)).toString());
      return checkDeviceInfo(info: Constants.globalConfig.deviceName);
    } else if(File(Constants.kVendorName).existsSync()){
      return checkDeviceInfo(info:  ( await _ioManager.readFile(Constants.kVendorName)).toString());
    }
    debugPrint("unknown device");
    return true;
  }

  @override
  Future<int> compatibilityChecker() async{

    if(!await isDeviceCompatible()){
      return 7;
    }

    if(!await _terminalDelegate.pkexecChecker()){
      return 6;
    }

    if(isMainLineCompatible()){
      if(await thresholdPathExists() && await systemHasSystemd()){
        _globalConfig.setInstance(arMode: ARMODE.mainline);
      }else{
        _globalConfig.setInstance(arMode:  ARMODE.mainlineWithoutBatteryManager);
      }
      return 4;
    }

    if(!checkFaustusFolder()) {
      if(await thresholdPathExists()&& await systemHasSystemd()) {
        return 3;
      } else {
        return 2;
      }
    }else if(await _terminalDelegate.isKernelCompatible()) {
      return 5;
    }

    if((await _permissionManager.listPackagesToInstall()).isNotEmpty) {
      return 1;
    }

    _globalConfig.setInstance(arMode: ARMODE.faustus);
    return 0;
  }

  @override
  int convertVersionToInt(String version) {
    return int.tryParse(version.replaceAll('.', '').replaceAll('+', '').split('-')[0])??0;
  }

  @override
  bool checkFaustusFolder()=>Directory(Constants.kFaustusModulePath).existsSync();

  Future _getAccess() async{
      await _permissionManager.setPermissions();
  }

  Future<bool> _checkAccess() async{
    return await _permissionManager.validatePaths() && await _terminalDelegate.arServiceEnabled();
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
  Future<bool> thresholdPathExists() async{
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
  Future<bool> systemHasSystemd() async{
    return (await _terminalDelegate.getOutput(command: Constants.kChecksystemd)).toString().contains('systemd');
  }

  @override
  Future initLog() async{
   _arLogger.log(data: "Build Version          : ${await getVersion()}");
   _arLogger.log(data: "Build Type             : ${Constants.buildType.name}");
   _arLogger.log(data: "Compatible Device      : ${await isDeviceCompatible()}");
   _arLogger.log(data: "Compatible Kernel      : ${await _terminalDelegate.isKernelCompatible()}");
   _arLogger.log(data: "Mainline Mode          : ${isMainLineCompatible()}");
   _arLogger.log(data: "System has systemd     : ${await systemHasSystemd()}");
   _arLogger.log(data: "Threshold Path Exists  : ${await thresholdPathExists()}");
  }


}