

import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/battery_manager/battery_manager_state/batter_manager_state.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatteryManagerCubit extends Cubit<BatteryManagerState>{
  BatteryManagerCubit(this._terminalRepo,this._prefRepo):super(BatteryManagerInit(batteryLevel: 50));

  final TerminalRepo _terminalRepo;
  PrefRepo _prefRepo;

  int _batteryLevel=50;

  Future getBatteryLevel() async {
    _batteryLevel= int.parse((await File("/sys/class/power_supply/BAT1/charge_control_end_threshold").readAsString()).toString().trim());
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  setBatteryLevel(int level){
    _batteryLevel=level;
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  finalizeBatteryLevel(int level){
    _batteryLevel=level;
    _terminalRepo.execute("${Constants.kExecBatteryManagerPath} $level");
    _prefRepo.setThreshold(level);
    emit(BatteryManagerInit(batteryLevel: _batteryLevel));
  }

  int get batteryLevel => _batteryLevel;
}