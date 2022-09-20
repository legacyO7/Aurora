import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {


  static String arVersion='-';
  static String kWorkingDirectory = '/';
  static const String kAssetsPath = "assets/scripts/";


  static const String kFaustus = 'faustus_controller.sh';
  static const String kBatteryManager = 'battery_manager.sh';
  static const String kSetup = 'ar_setup.sh';

  static String kExecFaustusPath = '';
  static String kExecBatteryManagerPath = '';

  static const String kPolkit = 'pkexec --disable-internal-agent';
  static const String kBatteryThresholdPath = '/sys/class/power_supply/BAT1/charge_control_end_threshold';

  static const int kMinimumChargeLevel = 50;

  static GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();


}