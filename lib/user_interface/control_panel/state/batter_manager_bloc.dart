import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/battery_manager_event.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'batter_manager_state.dart';

class BatteryManagerBloc extends TerminalBaseBloc<BatteryManagerEvent,BatteryManagerInit>{
  BatteryManagerBloc(this._prefRepo,this._homeRepo):super(const BatteryManagerInit()){
    on<BatteryManagerEventInit>((_, emit) => _getBatteryLevel(emit));
    on<BatteryManagerEventOnSlide>((event, emit) => _setBatteryLevel(event.value,emit));
    on<BatteryManagerEventOnSlideEnd>((event, emit) => _finalizeBatteryLevel(event.value,emit));
  }

  final PrefRepo _prefRepo;
  final HomeRepo _homeRepo;

  int _batteryLevel=Constants.kMinimumChargeLevel;

  Future _getBatteryLevel(emit) async {
    _batteryLevel= await _homeRepo.getBatteryCharge();
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
  bool get showBatterManager=> _homeRepo.systemHasSystemd();

}