
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState>{
  KeyboardSettingsBloc(this._prefRepo):super(const KeyboardSettingsState()){
   on<KeyboardSettingsEventSetBrightness>((event, emit)=> _setBrightness(event.brightness,emit));
   on<KeyboardSettingsEventSetSpeed>((event, emit)=> _setSpeed(event.speed,emit));
   on<KeyboardSettingsEventSetMode>((event, emit)=> _setMode(event.mode,emit));
   on<KeyboardSettingsEventSetColor>((event, emit)=> _setColor(event.color??ArColors.accentColor,emit));
   on<KeyboardSettingsEventInit>((event, emit) => _initPanel(emit));
  }

  final PrefRepo _prefRepo;
  Color _color=ArColors.accentColor;

  _initPanel(emit) async{
   await _setColor(await _prefRepo.getColor(), emit);
   await _setBrightness(await _prefRepo.getBrightness(), emit);
   await _setMode(await _prefRepo.getMode(), emit);
   await _setSpeed(await _prefRepo.getSpeed(), emit);
  }


  _setColor(Color color ,emit) async {
    _color= color;
    await super.execute("${Constants.globalConfig.kExecFaustusPath} color ${_color.red.toRadixString(16)} ${_color.green.toRadixString(16)} ${_color.blue.toRadixString(16)} 0");
    _prefRepo.setColor(_color.toString());
    ArColors.accentColor=_color;
    emit(state.copyState(color: _color));
  }

  _setBrightness(int brightness, emit) async {
    await super.execute("${Constants.globalConfig.kExecFaustusPath} brightness $brightness ");
    _prefRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  _setMode(int mode, emit)async{
    await super.execute("${Constants.globalConfig.kExecFaustusPath} mode $mode ");
    _prefRepo.setMode(mode);
    emit(state.copyState(mode: mode));
  }

  _setSpeed(int speed, emit) async{
    await super.execute("${Constants.globalConfig.kExecFaustusPath} speed $speed ");
    _prefRepo.setSpeed(speed);
    emit(state.copyState(speed: speed));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);


}