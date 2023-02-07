
import 'package:aurora/data/model/ar_state_model.dart';
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/control_panel_repo.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState> with GlobalMixin{
  KeyboardSettingsBloc(this._prefRepo,this._controlPanelRepo):super(const KeyboardSettingsState()){
   on<KeyboardSettingsEventSetBrightness>((event, emit)=> _setBrightness(event.brightness,emit));
   on<KeyboardSettingsEventSetSpeed>((event, emit)=> _setSpeed(event.speed,emit));
   on<KeyboardSettingsEventSetMode>((event, emit)=> _setMode(event.mode,emit));
   on<KeyboardSettingsEventSetColor>((event, emit)=> _setColor(color: event.color??ArColors.accentColor,mode: 0, emit));
   on<KeyboardSettingsEventInit>((event, emit) => _initPanel(emit));
   on<KeyboardSettingsEventSetState>((event, emit) => _setMainLineStateParams(emit,awake: event.awake,sleep: event.sleep,boot: event.boot));
  }

  final PrefRepo _prefRepo;
  final ControlPanelRepo _controlPanelRepo;
  Color _color=ArColors.accentColor;
  int _mode=0;
  int _speed=0;
  bool _boot=false;
  bool _awake=false;
  bool _sleep=false;


  final _globalConfig=Constants.globalConfig;

  _initPanel(emit) async{

      await _setBrightness(await _prefRepo.getBrightness(), emit);
      if(super.isMainLine()){
        await _setMainlineModeParams(
          color: await _prefRepo.getColor(),
          mode: await _prefRepo.getMode(),
          speed: await _prefRepo.getSpeed(),
          emit
        );

        ArState arState= await _prefRepo.getState();

        await _setMainLineStateParams(
          boot: !arState.boot!,
          sleep: !arState.sleep!,
          awake: !arState.awake!,
          emit
        );
      }else {
        await _setColor(color: await _prefRepo.getColor(), emit);
        await _setMode(await _prefRepo.getMode(), emit);
        await _setSpeed(await _prefRepo.getSpeed(), emit);
      }
  }

  _setColor(emit,{required Color color,int? mode}) async {
    _color= color;
    _mode=mode??_mode;
    if(super.isMainLine()){
      await _setMainlineModeParams(emit, color: _color,mode: _mode);
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
    await super.execute("${super.isMainLine()?_globalConfig.kExecMainlinePath: _globalConfig.kExecFaustusPath} brightness $brightness ");
    _prefRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  _setMode(int mode, emit)async{
    _mode=mode;
    if(super.isMainLine()){
      await _setMainlineModeParams(emit,mode: mode);
    }else {
      await super.execute("${_globalConfig.kExecFaustusPath} mode $mode ");
      _prefRepo.setMode(mode);
      emit(state.copyState(mode: mode));
    }
  }

  _setSpeed(int speed, emit) async{
    _speed=speed;
    if(super.isMainLine()){
      await _setMainlineModeParams(emit,speed: speed);
    }else {
      await super.execute("${_globalConfig.kExecFaustusPath} speed $speed ");
      _prefRepo.setSpeed(speed);
      emit(state.copyState(speed: speed));
    }
  }
  
  _setMainlineModeParams(emit,{
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
  
  _setMainLineStateParams(emit,{
    bool? boot,
    bool? awake,
    bool? sleep
  }) async{

    _boot=boot==null?_boot:!boot;
    _awake=awake==null?_awake:!awake;
    _sleep=sleep==null?_sleep:!sleep;

    await _controlPanelRepo.saveState(sleep: _parseBool(_sleep),awake: _parseBool(_awake),boot: _parseBool(_boot));
    emit(state.copyState(boot: _boot,sleep: _sleep, awake: _awake));
  }

  _parseBool(bool? value)=>(value??false)?1:0;

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);


}