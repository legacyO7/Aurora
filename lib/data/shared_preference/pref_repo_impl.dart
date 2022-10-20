
import 'package:aurora/data/shared_preference/pref_constants.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pref_repo.dart';

class PrefRepoImpl extends PrefRepo{
  PrefRepoImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<String?> getVersion() async {
    return _sharedPreferences.getString(PrefConstants.version)??'0';
  }

  @override
  Future<Color> getColor() async {
    return Color(int.parse((_sharedPreferences.getString(PrefConstants.color)??ArColors.blue.toString()).split('(0x')[1].split(')')[0],radix: 16));
  }

  @override
  Future<int> getBrightness() async {
    return (_sharedPreferences.getInt(PrefConstants.brightness))??0;
  }

  @override
  Future<int> getMode() async {
    return (_sharedPreferences.getInt(PrefConstants.mode))??0;
  }

  @override
  Future<int> getSpeed() async {
    return (_sharedPreferences.getInt(PrefConstants.speed))??0;
  }

  @override
  Future<int> getThreshold() async{
    return (_sharedPreferences.getInt(PrefConstants.threshold))??Constants.kMinimumChargeLevel;
  }

  @override
  Future setVersion(String version) async {
    await _sharedPreferences.setString(PrefConstants.version, version);
  }

  @override
  Future setColor(String color) async {
    await _sharedPreferences.setString(PrefConstants.color, color);
  }

  @override
  Future setBrightness(int brightness) async {
    await _sharedPreferences.setInt(PrefConstants.brightness, brightness);
  }

  @override
  Future setMode(int mode) async {
    await _sharedPreferences.setInt(PrefConstants.mode, mode);
  }

  @override
  Future setSpeed(int speed) async {
    await _sharedPreferences.setInt(PrefConstants.speed, speed);
  }

  @override
  Future setThreshold(int threshold) async {
    await _sharedPreferences.setInt(PrefConstants.threshold, threshold);
  }
}
