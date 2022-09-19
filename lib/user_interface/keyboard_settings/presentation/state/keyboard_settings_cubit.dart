
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsCubit extends Cubit<KeyboardSettingsState>{
  KeyboardSettingsCubit(this._prefRepo,this._terminalRepo):super(KeyboardSettingsInit());

  final PrefRepo _prefRepo;
  final TerminalRepo _terminalRepo;

  int? _brightness;
  int? _mode;
  int? _speed;
  Color _color=Colors.green;

  Future initPanel()async{
    setColor(await _prefRepo.getColor());
    setBrightness(await _prefRepo.getBrightness());
    setMode(await _prefRepo.getMode());
    setSpeed(await _prefRepo.getSpeed());
  }

  setColor(Color color) async {
    _color= color;
    await _terminalRepo.execute("${Constants.kExecFaustusPath} color ${_color.red.toRadixString(16)} ${_color.green.toRadixString(16)} ${_color.blue.toRadixString(16)} 0");
    _prefRepo.setColor(_color.toString());
    emit(KeyboardSettingsColorPanel(color: _color));

  }

  setBrightness(int value) async {
    _brightness=value;
    await _terminalRepo.execute("${Constants.kExecFaustusPath} brightness $_brightness ");
    _prefRepo.setBrightness(value);
    emit(KeyboardSettingsBrightnessPanel(brightness: _brightness??0));
  }

  setMode(int value)async{
    _mode=value;
    await _terminalRepo.execute("${Constants.kExecFaustusPath} mode $_mode ");
    _prefRepo.setMode(value);
    emit(KeyboardSettingsModePanel(mode: _mode??0));
  }

  setSpeed(int value) async{
    _speed=value;
    await _terminalRepo.execute("${Constants.kExecFaustusPath} speed $_speed ");
    _prefRepo.setSpeed(value);
    emit(KeyboardSettingsSpeedPanel(speed: _speed??0));
  }

  bool get isSpeedBarVisible => (_mode??0)>0&&(mode??0)<3&&isModeBarVisible;
  bool get isModeBarVisible => (_brightness??0)>0;

  int? get brightness => _brightness;
  int? get speed => _speed;
  int? get mode => _mode;
  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);

}