import 'package:aurora/data/model/ar_mode_model.dart';
import 'package:aurora/data/model/ar_state_model.dart';
import 'package:flutter/material.dart';

abstract class PrefRepo{

  Future<String?> getVersion();
  Future<int> getBrightness();
  Future<ArMode?> getArMode();
  Future<ArState> getArState();
  Future<int> getThreshold();
  Future<ThemeMode> getTheme();

  Future setVersion(String version);
  Future setBrightness(int brightness);
  Future setArMode({ required ArMode arMode});
  Future setArState({ required ArState arState });
  Future setThreshold(int threshold);
  Future setTheme(ThemeMode arTheme);
  Future nukePref();

}