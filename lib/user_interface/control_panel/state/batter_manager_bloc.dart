import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/battery_manager_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'batter_manager_state.dart';

class BatteryManagerBloc extends TerminalBaseBloc<BatteryManagerEvent,BatteryManagerInit>{
  BatteryManagerBloc(this._prefRepo):super(const BatteryManagerInit()){
    on<EventBMInit>((_, emit) => _getBatteryLevel(emit));
    on<EventBMOnSlide>((event, emit) => _setBatteryLevel(event.value,emit));
    on<EventBMOnSlideEnd>((event, emit) => _finalizeBatteryLevel(event.value,emit));
  }

  final PrefRepo _prefRepo;

  int _batteryLevel=Constants.kMinimumChargeLevel;

  Future _getBatteryLevel(emit) async {
    _batteryLevel= int.parse((await File(Constants.kBatteryThresholdPath).readAsString()).toString().trim());
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  _setBatteryLevel(int level,emit){
    _batteryLevel=level;
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  _finalizeBatteryLevel(int level,emit) async{
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