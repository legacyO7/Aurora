
import 'package:aurora/data/di/shared_preference/pref_constants.dart';
import 'package:aurora/data/di/shared_preference/pref_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'control_panel_state.dart';

class ControlPanelCubit extends Cubit<ControlPanelState>{
  ControlPanelCubit(this._prefRepo):super(ControlPanelInit());

  final PrefRepo _prefRepo;

  int? _brightness;
  int? _mode;
  int? _speed;
  Color _color=Colors.green;

  Future<Map<String,dynamic>> initPanel()async{
    setColor(await _prefRepo.getColor());
    setBrightness(await _prefRepo.getBrightness());
    setMode(await _prefRepo.getMode());
    setSpeed(await _prefRepo.getSpeed());
    
    return{
      PrefConstants.brightness:_brightness,
      PrefConstants.color:_color,
      PrefConstants.speed:_speed,
      PrefConstants.mode:_mode,
    };
  }

  setColor(Color color){
    _color= color;
    _prefRepo.setColor(color.toString());
    emit(CPColorPanel(color: _color));
  }

  setBrightness(int value){
    _brightness=value;
    _prefRepo.setBrightness(value);
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }

  setMode(int value){
    _mode=value;
    _prefRepo.setMode(value);
    emit(CPModePanel(mode: _mode??0));
  }

  setSpeed(int value){
    _speed=value;
    _prefRepo.setSpeed(value);
    emit(CPSpeedPanel(speed: _speed??0));
  }

  bool get isSpeedBarVisible => (_mode??0)>0&&(mode??0)<3&&isModeBarVisible;
  bool get isModeBarVisible => (_brightness??0)>0;

  int? get brightness => _brightness;
  int? get speed => _speed;
  int? get mode => _mode;
  Color get selectedColor => _color;
  Color get invertedSelectedColor => Color.fromARGB((_color.opacity * 255).round(), 255-_color.red, 255-_color.green, 255-_color.blue);

}