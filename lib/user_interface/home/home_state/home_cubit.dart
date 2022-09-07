import 'dart:io';

import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState>{
  TerminalRepo _terminalRepo;

  HomeCubit(this._terminalRepo) : super(HomeStateInit());

  Color _selectedColor=Colors.green;

  Future execute(String command) async {
    await for (var line in _terminalRepo.execute(command)) {
      emit(AccessGranted(terminalOp: line, inProgress: _terminalRepo.isInProgress(), hasRootAccess: _terminalRepo.checkRootAccess()));
    }
  }

  void requestAccess(){
    execute("pkexec ${Directory.current.path}/assets/scripts/faustus_controller.sh");
  }

  Future<bool> setColor(color) async{
    _selectedColor= color;
    await execute("${Directory.current.path}/assets/scripts/faustus_controller.sh color ${color.red.toRadixString(16)} ${color.green.toRadixString(16)} ${color.blue.toRadixString(16)} 0");
    return _terminalRepo.checkRootAccess();
  }

  Future<bool> setBrightness(value) async{
    await execute("${Directory.current.path}/assets/scripts/faustus_controller.sh brightness $value ");
    return _terminalRepo.checkRootAccess();
  }

  void killProcess(){
    _terminalRepo.killProcess();
  }

  Color get selectedColor => _selectedColor;
}