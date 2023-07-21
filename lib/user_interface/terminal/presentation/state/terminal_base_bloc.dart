import 'package:aurora/shared/shared.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/ar_widgets/cubits/color_cubit.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TerminalBaseBloc<Event,State> extends Bloc<Event,State> with GlobalMixin{

  TerminalBaseBloc(State initialState) : super(initialState);

  final TerminalRepo _terminalRepo = sl<TerminalRepo>();
  final ArButtonCubit _arButtonCubit = sl<ArButtonCubit>();
  final ArColorCubit _arColorCubit = sl<ArColorCubit>();

  void killProcess() {
    _terminalRepo.killProcess();
  }

  void clearTerminalOutput(){
    _terminalRepo.clearTerminalOut();
  }

  void dispose(){
    _terminalRepo.disposeStream();
  }

  void setLoad()=>_arButtonCubit.setLoad();
  void setUnLoad()=>_arButtonCubit.setUnLoad();

  void setSelectedColor(Color color)=>_arColorCubit.setSelectedColor(selectedColor: color);

  Color get selectedColor =>_arColorCubit.selectedColor;
  Color get selectedColorWithAlpha =>_arColorCubit.selectedColorWithAlpha;
  Color get invertedColor =>_arColorCubit.invertedColor;

  void restartApp()=> sl<SetupBloc>().add(SetupEventRebirth());


  Stream<List<String>> get terminalOutput => _terminalRepo.terminalOutStream;

}