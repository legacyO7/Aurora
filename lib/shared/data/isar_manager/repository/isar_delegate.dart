import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:flutter/material.dart';

abstract class IsarDelegate{
  String getVersionFromDB();
  Future<ThemeMode> getTheme();
  bool getEnforceFaustus();
  Future saveVersion(String version);
  Future saveTheme(ThemeMode themeMode);
  Future setEnforceFaustus(bool enforced);
  Future<ArProfileModel> getArProfile({int? id});

  int getThreshold();
  Future setBrightness(int brightness);
  Future setArMode({ required ArMode arMode});
  Future setArState({ required ArState arState });
  Future setThreshold(int threshold);
  Future<ArProfileModel?> readFromProfileName(String profileName);

  Future deleteDatabase();
}