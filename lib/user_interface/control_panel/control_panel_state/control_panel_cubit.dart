import 'package:flutter_bloc/flutter_bloc.dart';

import 'control_panel_state.dart';

class ControlPanelCubit extends Cubit<ControlPanelState>{
  ControlPanelCubit():super(ControlPanelInit());


  int? _brightness;

  setBrightness(int? value){
    _brightness=value;
    emit(CPBrightnessPanel(brightness: _brightness??0));
  }



  int? get brightness => _brightness;
}