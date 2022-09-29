
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsCubit extends TerminalBaseCubit<KeyboardSettingsLoadedState>{
  KeyboardSettingsCubit(this._prefRepo):super(const KeyboardSettingsLoadedState());

  final PrefRepo _prefRepo;

  Color _color=Colors.green;

  Future initPanel() async{
    await setColor(await _prefRepo.getColor());
    await setBrightness(await _prefRepo.getBrightness());
    await setMode(await _prefRepo.getMode());
    await setSpeed(await _prefRepo.getSpeed());
  }

  setColor(Color color) async {
    _color= color;
    await super.execute("${Constants.kExecFaustusPath} color ${_color.red.toRadixString(16)} ${_color.green.toRadixString(16)} ${_color.blue.toRadixString(16)} 0");
    _prefRepo.setColor(_color.toString());
    emit(state.copyState(color: _color));
  }

  setBrightness(int value) async {
    await super.execute("${Constants.kExecFaustusPath} brightness $value ");
    _prefRepo.setBrightness(value);
    emit(state.copyState(brightness: value));
  }

  setMode(int value)async{
    await super.execute("${Constants.kExecFaustusPath} mode $value ");
    _prefRepo.setMode(value);
    emit(state.copyState(mode: value));
  }

  setSpeed(int value) async{
    await super.execute("${Constants.kExecFaustusPath} speed $value ");
    _prefRepo.setSpeed(value);
    emit(state.copyState(speed: value));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);

}