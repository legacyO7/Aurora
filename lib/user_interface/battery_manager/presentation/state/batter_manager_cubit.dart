

import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'batter_manager_state.dart';

class BatteryManagerCubit extends Cubit<BatteryManagerState>{
  BatteryManagerCubit(this._terminalRepo,this._prefRepo):super(BatteryManagerInit(batteryLevel: Constants.kMinimumChargeLevel));

  final TerminalRepo _terminalRepo;
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
    await _terminalRepo.execute("${Constants.kExecBatteryManagerPath} $level");
    await _prefRepo.setThreshold(level);
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  Color getSliderColor(Color color){
    return HSLColor.fromColor(color).withHue(100-((_batteryLevel-Constants.kMinimumChargeLevel)/Constants.kMinimumChargeLevel)*100).toColor();
  }

  int get batteryLevel => _batteryLevel;
}