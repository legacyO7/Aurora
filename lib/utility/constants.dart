import 'package:aurora/utility/ar_widgets/ar_enums.dart';
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
  static const String kArServiceStatus = 'systemctl status aurora-controller.service';

  //paths
  static const String kFaustusModulePath = "/sys/devices/platform/faustus/";
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

}