import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/terminal/domain/model/terminal_text.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';

import 'terminal_state.dart';

class TerminalCubit extends TerminalBaseBloc<KeyboardSettingsEvent,TerminalState>{
  TerminalCubit():super(TerminalStateInit()){

    super.terminalOutput.listen((event) {
      emit(TerminalStateLoaded(terminalOut: event));
    });
  }

  void killCurrentProcess(){
    super.killProcess();
  }

  TerminalText convertToTerminalText({required String line}){

      if(line.split(' ')[0] == CommandStatus.stdout.name){
        return TerminalText(text: line, commandStatus: CommandStatus.stdout );
      }else if(line.split(' ')[0] == CommandStatus.stdin.name){
        return (TerminalText(text: line, commandStatus: CommandStatus.stdin ));
      }
      return (TerminalText(text: line, commandStatus:  CommandStatus.stderr));
  }

}