import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/di/di.dart';
import 'ar_widgets/ar_enums.dart';
import 'constants.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.arMode==ARMODE.mainline;

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

  ThemeData setTheme(context,{bool light=true}) {
    return ThemeData(
      fontFamily: 'Play',
      brightness: light ? Brightness.light : Brightness.dark,
      textTheme:  TextTheme(
        bodyMedium: TextStyle(fontSize: 2.1.w),
      ).apply(
        bodyColor: light?ArColors.black:ArColors.white
      )
    );
  }


}