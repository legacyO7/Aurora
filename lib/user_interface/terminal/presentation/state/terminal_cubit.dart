import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';

import 'terminal_state.dart';

class TerminalCubit extends TerminalBaseCubit<TerminalState>{
  TerminalCubit():super(TerminalStateInit()){

    super.terminalOutput.listen((event) {
      emit(TerminalStateLoaded(terminalOut: event));
    });
  }

  void killCurrentProcess(){
    super.killProcess();
  }

}