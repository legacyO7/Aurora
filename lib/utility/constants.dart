import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:flutter/material.dart';

import '../data/init_aurora.dart';
import 'global_configuration.dart';

class Constants {

  static final GlobalConfig globalConfig=sl<GlobalConfig>();

  //files
  static const String kBatteryManager = 'battery_manager.sh';
  static const String kArSetup = 'ar_setup.sh';
  static const String kFaustusInstaller = 'install_faustus.sh';

  //commands
  static const String kPolkit = 'pkexec --disable-internal-agent';
  static const String kArServiceStatus = 'systemctl status aurora-controller.service';
  static const String kChecksystemd = 'ps --no-headers -o comm 1';

  //paths
  static const String kFaustusModulePath = "/sys/devices/platform/faustus/";
  static const String kFaustusModuleBrightnessPath = '${kFaustusModulePath}leds/asus::kbd_backlight/brightness';
  static const String kFaustusModuleRedPath = "${kFaustusModulePath}kbbl/kbbl_red";
  static const String kFaustusModuleGreenPath = "${kFaustusModulePath}kbbl/kbbl_green";
  static const String kFaustusModuleBluePath = "${kFaustusModulePath}kbbl/kbbl_blue";
  static const String kFaustusModuleModePath = "${kFaustusModulePath}kbbl/kbbl_mode";
  static const String kFaustusModuleSpeedPath = "${kFaustusModulePath}kbbl/kbbl_speed";
  static const String kFaustusModuleFlagsPath = "${kFaustusModulePath}kbbl/kbbl_flags";
  static const String kFaustusModuleSetPath = "${kFaustusModulePath}kbbl/kbbl_set";

  static const String kMainlineModuleModePath = "/sys/class/leds/asus::kbd_backlight/kbd_rgb_mode";
  static const String kMainlineModuleStatePath = "/sys/class/leds/asus::kbd_backlight/kbd_rgb_state";
  static const String kMainlineBrightnessPath = "/sys/class/leds/asus::kbd_backlight/brightness";
  static const String kAssetsPath = "assets/scripts/";
  static const String kPowerSupplyPath = '/sys/class/power_supply/';
  static const String kServicePath = '/etc/systemd/system/';
  static const String kProductName = '/sys/devices/virtual/dmi/id/product_name';
  static const String kVendorName = '/sys/devices/virtual/dmi/id/sys_vendor';

  //url
  static const String kAuroraGitUrl = "https://github.com/legacyO7/Aurora";
  static const String kTerminalListUrl = "https://raw.githubusercontent.com/i3/i3/next/i3-sensible-terminal";

  static const int kMinimumChargeLevel = 50;

  //keys
  static GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();

  //build type
  static const BuildType buildType= BuildType.debug;
  
  //flags
  static bool isLoggingEnabled=false;

}