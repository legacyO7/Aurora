import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_event.dart';
import 'batter_manager_state.dart';

class BatteryManagerCubit extends TerminalBaseBloc<KeyboardSettingsEvent,BatteryManagerInit>{
  BatteryManagerCubit(this._prefRepo):super(const BatteryManagerInit());

  final PrefRepo _prefRepo;

  int _batteryLevel=Constants.kMinimumChargeLevel;

  Future getBatteryLevel() async {
    _batteryLevel= int.parse((await File(Constants.kBatteryThresholdPath).readAsString()).toString().trim());
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  setBatteryLevel(int level){
    _batteryLevel=level;
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  finalizeBatteryLevel(int level) async{
    _batteryLevel=level;
    await super.execute("${Constants.kExecBatteryManagerPath} $level");
    await _prefRepo.setThreshold(level);
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  Color getSliderColor(Color color){
    return HSLColor.fromColor(color).withHue(100-((_batteryLevel-Constants.kMinimumChargeLevel)/Constants.kMinimumChargeLevel)*100).toColor();
  }

  int get batteryLevel => _batteryLevel;
}