import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {


  static String arVersion='-';

  static const String kFaustus = 'faustus_controller.sh';
  static const String kBatteryManager = 'battery_manager.sh';
  static const String kArSetup = 'ar_setup.sh';
  static const String kFaustusInstaller = 'install_faustus.sh';

  static const String kPolkit = 'pkexec --disable-internal-agent';

  static String kExecFaustusPath = '';
  static String kExecBatteryManagerPath = '';
  static String kFaustusGitUrl = "https://github.com/legacyO7/faustus.git";
  static String kWorkingDirectory = '/';
  static const String kAssetsPath = "assets/scripts/";
  static const String kBatteryThresholdPath = '/sys/class/power_supply/BAT1/charge_control_end_threshold';

  static const int kMinimumChargeLevel = 50;
  static bool kSecureBootEnabled = false;

  static GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();


}