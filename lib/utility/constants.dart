import 'package:flutter/material.dart';

import '../data/di/di.dart';
import 'global_configuration.dart';

class Constants {

  static final GlobalConfig globalConfig=sl<GlobalConfig>();

  //files
  static const String kFaustus = 'faustus_controller.sh';
  static const String kMainline = 'mainline_controller.sh';
  static const String kBatteryManager = 'battery_manager.sh';
  static const String kArSetup = 'ar_setup.sh';
  static const String kFaustusInstaller = 'install_faustus.sh';
  static const String kPermissionChecker = 'permission_checker.sh';

  //commands
  static const String kPolkit = 'pkexec --disable-internal-agent';

  //paths
  static const String kFaustusModulePath = "/sys/devices/platform/faustus/";
  static const String kMainlineModuleModePath = "/sys/class/leds/asus::kbd_backlight/kbd_rgb_mode";
  static const String kMainlineModuleStatePath = "/sys/class/leds/asus::kbd_backlight/kbd_rgb_state";
  static const String kMainlineBrightnessPath = "/sys/class/leds/asus::kbd_backlight/brightness";
  static const String kAssetsPath = "assets/scripts/";
  static const String kBatteryThresholdPath = '/sys/class/power_supply/BAT1/charge_control_end_threshold';
  static const String kServicePath = '/etc/systemd/system/';

  //url
  static const String kAuroraGitUrl = "https://github.com/legacyO7/Aurora";
  static const String kTerminalListUrl = "https://raw.githubusercontent.com/i3/i3/next/i3-sensible-terminal";

  static const int kMinimumChargeLevel = 50;

  //keys
  static GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();

}