import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'control_panel_state.dart';

class ControlPanelCubit extends Cubit<ControlPanelState>{
  ControlPanelCubit():super(ControlPanelInit());


  int? _brightness;
  int? _mode;
  int? _speed;
  Color _selectedColor=Colors.green;

  setColor(Color color){
    _selectedColor= color;
    emit(CPColorPanel(color: _selectedColor));
  }

  setBrightness(int? value){
    _brightness=value;
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }

  setMode(int? value){
    _mode=value;
    emit(CPModePanel(mode: _mode??0));
  }

  setSpeed(int? value){
    _speed=value;
    emit(CPSpeedPanel(speed: _speed??0));
  }

  bool get isSpeedBarVisible => (_mode??0)>0&&(mode??0)<3;

  int? get brightness => _brightness;
  int? get speed => _speed;
  int? get mode => _mode;
  Color get selectedColor => _selectedColor;

}