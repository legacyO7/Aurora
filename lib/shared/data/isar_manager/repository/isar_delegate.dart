import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:flutter/material.dart';

abstract class IsarDelegate{
  String getVersion();
  Future<ThemeMode> getTheme();
  bool getEnforceFaustus();
  Future setVersion(String version);
  Future setTheme(ThemeMode themeMode);
  Future setEnforceFaustus(bool enforced);
  Future<ArProfileModel> getArProfile({int? id});

  int getThreshold();
  Future setBrightness(int brightness);
  Future setArMode({ required ArMode arMode});
  Future setArState({ required ArState arState });
  Future setThreshold(int threshold);

  Future deleteDatabase();
}