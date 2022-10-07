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
  static const String kAuroraGitUrl = "https://github.com/legacyO7/Aurora";
  static String kFaustusGitUrl = "https://github.com/legacyO7/faustus.git";
  static const String kFaustusModulePath = "/sys/devices/platform/faustus/";
  static const String kTerminalListUrl = "https://raw.githubusercontent.com/i3/i3/next/i3-sensible-terminal";
  static String kWorkingDirectory = '/';
  static const String kAssetsPath = "assets/scripts/";
  static const String kBatteryThresholdPath = '/sys/class/power_supply/BAT1/charge_control_end_threshold';

  static const int kMinimumChargeLevel = 50;
  static bool kSecureBootEnabled = false;

  static GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();

  static Color arColor= Colors.green;


}