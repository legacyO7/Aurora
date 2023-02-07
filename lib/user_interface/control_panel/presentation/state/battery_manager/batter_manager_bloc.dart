import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/battery_manager_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'batter_manager_state.dart';

class BatteryManagerBloc extends TerminalBaseBloc<BatteryManagerEvent,BatteryManagerInit>{
  BatteryManagerBloc(this._batteryManagerRepo):super(const BatteryManagerInit()){
    on<BatteryManagerEventInit>((_, emit) => _getBatteryLevel(emit));
    on<BatteryManagerEventOnSlide>((event, emit) => _setBatteryLevel(event.value,emit));
    on<BatteryManagerEventOnSlideEnd>((event, emit) => _finalizeBatteryLevel(event.value,emit));
  }

  final BatteryManagerRepo _batteryManagerRepo;

  int _batteryLevel=Constants.kMinimumChargeLevel;

  Future _getBatteryLevel(emit) async {
    _batteryLevel= await _batteryManagerRepo.getBatteryCharge();
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  _setBatteryLevel(int level,emit){
    _batteryLevel=level;
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  _finalizeBatteryLevel(int level,emit) async{
    _batteryLevel=level;
    await _batteryManagerRepo.setBatteryChargeLimit(limit: level);
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  Color getSliderColor(Color color){
    return HSLColor.fromColor(color).withHue(100-((_batteryLevel-Constants.kMinimumChargeLevel)/Constants.kMinimumChargeLevel)*100).toColor();
  }

  int get batteryLevel => _batteryLevel;

}