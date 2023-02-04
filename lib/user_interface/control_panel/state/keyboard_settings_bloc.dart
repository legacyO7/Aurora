
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
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
  int _mode=0;
  int _speed=0;

  final _globalConfig=Constants.globalConfig;

  _initPanel(emit) async{

      await _setBrightness(await _prefRepo.getBrightness(), emit);
      if(_globalConfig.isMainLine()){
        await _setMainlineParams(
          color: await _prefRepo.getColor(),
          mode: await _prefRepo.getMode(),
          speed: await _prefRepo.getSpeed(),
          emit
        );
      }else {
        await _setColor(await _prefRepo.getColor(), emit);
        await _setMode(await _prefRepo.getMode(), emit);
        await _setSpeed(await _prefRepo.getSpeed(), emit);
      }
  }

  _setColor(Color color ,emit) async {
    _color= color;
    if(_globalConfig.isMainLine()){
      await _setMainlineParams(emit, color: _color);
    }else {
      await super.execute(
          "${_globalConfig.kExecFaustusPath} color ${_color.red
              .toRadixString(16)} ${_color.green.toRadixString(16)} ${_color
              .blue.toRadixString(16)} 0");
    }
    _prefRepo.setColor(_color.toString());
    ArColors.accentColor=_color;
    emit(state.copyState(color: _color));
  }

  _setBrightness(int brightness, emit) async {
    await super.execute("${_globalConfig.isMainLine()?_globalConfig.kExecMainlinePath: _globalConfig.kExecFaustusPath} brightness $brightness ");
    _prefRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  _setMode(int mode, emit)async{
    _mode=mode;
    if(_globalConfig.isMainLine()){
      await _setMainlineParams(emit,mode: mode);
    }else {
      await super.execute("${_globalConfig.kExecFaustusPath} mode $mode ");
      _prefRepo.setMode(mode);
      emit(state.copyState(mode: mode));
    }
  }

  _setSpeed(int speed, emit) async{
    _speed=speed;
    if(_globalConfig.isMainLine()){
      await _setMainlineParams(emit,speed: speed);
    }else {
      await super.execute("${_globalConfig.kExecFaustusPath} speed $speed ");
      _prefRepo.setSpeed(speed);
      emit(state.copyState(speed: speed));
    }
  }
  
  _setMainlineParams(emit,{
    int? mode,
    Color? color,
    int? speed    
  }) async{
    _color=color??_color;
    _mode=mode??_mode;
    _speed=speed??_speed;

    await super.execute("${_globalConfig.kExecMainlinePath} mode 1 $_mode ${_color.red} ${_color.green} ${_color.blue} $_speed");
    emit(state.copyState(speed: _speed,mode: _mode,color: _color));
    _prefRepo.setColor(_color.toString());
    _prefRepo.setSpeed(_speed);
    _prefRepo.setMode(_mode);
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);


}