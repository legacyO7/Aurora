
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState>{
  KeyboardSettingsBloc(this._prefRepo):super(const KeyboardSettingsState()){
   on<EventKSBrightness>(setBrightnessEvent);
   on<EventKSSpeed>(setSpeedEvent);
   on<EventKSMode>(setModeEvent);
   on<EventKSColor>(setColorEvent);
   on<EventKSInit>(initPanel);
  }

  final PrefRepo _prefRepo;

  Color _color=Constants.arColor;

  initPanel(KeyboardSettingsEvent event,Emitter<KeyboardSettingsState> emit) async{
    await setBrightnessEvent(EventKSBrightness(brightness: await _prefRepo.getBrightness()), emit);
    await setModeEvent(EventKSMode(mode: await _prefRepo.getMode()), emit);
    await setSpeedEvent(EventKSSpeed(speed: await _prefRepo.getSpeed()), emit);
    await setColorEvent(EventKSColor(color: await _prefRepo.getColor()), emit);
  }


  setColorEvent(EventKSColor event, Emitter<KeyboardSettingsState> emit) async {
    _color= event.color??Constants.arColor;
    await super.execute("${Constants.kExecFaustusPath} color ${_color.red.toRadixString(16)} ${_color.green.toRadixString(16)} ${_color.blue.toRadixString(16)} 0");
    _prefRepo.setColor(_color.toString());
    Constants.arColor=_color;
    emit(state.copyState(color: _color));
  }

  setBrightnessEvent(EventKSBrightness event, Emitter<KeyboardSettingsState> emit) async {
    await super.execute("${Constants.kExecFaustusPath} brightness ${event.brightness} ");
    _prefRepo.setBrightness(event.brightness);
    emit(state.copyState(brightness: event.brightness));
  }


  setModeEvent(EventKSMode event, Emitter<KeyboardSettingsState> emit)async{
    await super.execute("${Constants.kExecFaustusPath} mode ${event.mode} ");
    _prefRepo.setMode(event.mode);
    emit(state.copyState(mode: event.mode));
  }

  setSpeedEvent(EventKSSpeed event, Emitter<KeyboardSettingsState> emit) async{
    await super.execute("${Constants.kExecFaustusPath} speed ${event.speed} ");
    _prefRepo.setSpeed(event.speed);
    emit(state.copyState(speed: event.speed));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);


}