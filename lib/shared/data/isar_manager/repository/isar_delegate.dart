import 'package:flutter/material.dart';

abstract class IsarDelegate{
  String getVersion();
  Future<ThemeMode> getTheme();
  bool getEnforceFaustus();
  Future setVersion(String version);
  Future setTheme(ThemeMode themeMode);
  Future setEnforceFaustus(bool enforced);
  Future deleteDatabase();
}