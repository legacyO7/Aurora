import 'dart:ui';

import 'package:aurora/data/model/ar_state_model.dart';
import 'package:flutter/material.dart';

abstract class PrefRepo{

  Future<String?> getVersion();
  Future<int> getBrightness();
  Future<Color> getColor();
  Future<int> getMode();
  Future<int> getSpeed();
  Future<ArState> getState();
  Future<int> getThreshold();
  Future<ThemeMode> getTheme();

  Future setVersion(String version);
  Future setBrightness(int brightness);
  Future setColor(String color);
  Future setMode(int mode);
  Future setSpeed(int speed);
  Future setState({ required bool boot, required bool awake, required bool sleep });
  Future setThreshold(int threshold);
  Future setTheme(ThemeMode arTheme);

}