import 'dart:io';

import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'ar_widgets/ar_enums.dart';
import 'constants.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.arMode.name.contains(ArModeEnum.mainline.name);

  bool canLog()=> Constants.globalConfig.isLoggingEnabled || Constants.buildType==BuildType.debug;

  bool isInstalledPackage() => Constants.buildType==BuildType.deb||Constants.buildType==BuildType.rpm;

  bool isFallbackedWorkingDirectory()=>Constants.globalConfig.kWorkingDirectory=='/tmp';

  Future<String> getVersion() async{
    var version= (await PackageInfo.fromPlatform()).version;
    Constants.globalConfig.setInstance(
        arVersion:version,
        arChannel: version.split('-')[1]
    );
    return version;
  }
  
  List<String> kernelModules(ArModules? module){
    ArModules arModule=module??(isMainLine()?ArModules.mainline:ArModules.faustus);

    if(arModule==ArModules.faustus){
      return ['faustus'];
    }
    if(arModule==ArModules.mainline){
      return ['asus-nb-wmi','asus-wmi','asus_nb_wmi','asus_wmi'];
    }

    return [];
  }


  bool isMainLineCompatible()=>
      File(Constants.kMainlineModuleModePath).existsSync() &&
      File(Constants.kMainlineModuleStatePath).existsSync() &&
      File(Constants.kMainlineBrightnessPath).existsSync();

  bool isDark({BuildContext? context})=>
    Theme.of(context??Constants.kScaffoldKey.currentState!.context).brightness==Brightness.dark;

  ThemeData setTheme([bool light=true]) {
    return ThemeData(
      fontFamily: 'Play',
      brightness: light ? Brightness.light : Brightness.dark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ArColors.transparent,
        foregroundColor:light?ArColors.black:ArColors.white, ),
      textTheme:  TextTheme(
        bodyMedium: TextStyle(fontSize: 13.sp),
        headlineSmall:  TextStyle(fontSize: 13.5.sp),
        headlineLarge:  TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold),
      ).apply(
        bodyColor: light?ArColors.black:ArColors.white,
      )
    );
  }


  ThemeData lightTheme()=> setTheme();
  ThemeData darkTheme()=> setTheme(false);


}