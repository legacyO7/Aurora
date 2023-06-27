import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'warmup.dart';
import 'ar_widgets/ar_enums.dart';
import 'constants.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.arMode.name.contains(ARMODE.mainline.name);

  bool isMainLineCompatible()=>
      File(Constants.kMainlineModuleModePath).existsSync() &&
      File(Constants.kMainlineModuleStatePath).existsSync() &&
      File(Constants.kMainlineBrightnessPath).existsSync();

  bool isDark({BuildContext? context})=>
    Theme.of(context??Constants.kScaffoldKey.currentState!.context).brightness==Brightness.dark;

  Future<bool> arServiceEnabled() async{
    return (await sl<TerminalRepo>().getOutput(command: Constants.kArServiceStatus))
        .toString().contains('aurora-controller.service; enabled');

  }

  ThemeData _setTheme([bool light=true]) {
    return ThemeData(
      fontFamily: 'Play',
      brightness: light ? Brightness.light : Brightness.dark,
      textTheme:  TextTheme(
        bodyMedium: TextStyle(fontSize: 13.sp),
        headlineSmall:  TextStyle(fontSize: 13.5.sp),
        headlineLarge:  TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold),
      ).apply(
        bodyColor: light?ArColors.black:ArColors.white
      )
    );
  }


  ThemeData lightTheme()=> _setTheme();
  ThemeData darkTheme()=> _setTheme(false);


}