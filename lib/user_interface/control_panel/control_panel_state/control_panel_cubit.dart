import 'package:flutter_bloc/flutter_bloc.dart';

import 'control_panel_state.dart';

class ControlPanelCubit extends Cubit<ControlPanelState>{
  ControlPanelCubit():super(ControlPanelInit());


  int? _brightness;
  int? _mode;
  int? _speed;

  setBrightness(int? value){
    _brightness=value;
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }

  setMode(int? value){
    _mode=value;
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }

  setSpeed(int? value){
    _speed=value;
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }

  int? get brightness => _brightness;
  int? get speed => _speed;
  int? get mode => _mode;
}