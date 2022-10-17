import 'package:aurora/user_interface/terminal/domain/model/terminal_text.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_event.dart';

import 'terminal_state.dart';

class TerminalBloc extends TerminalBaseBloc<TerminalEvent,TerminalState>{
  TerminalBloc():super(TerminalStateInit()){
   on<TerminalEventListen>((_, emit) => _listenToTerminal(emit));
   on<TerminalEventKill>((_, __) => _killCurrentProcess());
   on<TerminalEventDispose>((_, __) => _dispose());
  }
  
  void _listenToTerminal(emit){
    super.terminalOutput.listen((event) {
      emit(TerminalStateLoaded(terminalOut: event));
    });
  }

  void _killCurrentProcess(){
    super.killProcess();
  }

  void _dispose(){
    super.dispose();
  }

  TerminalText convertToTerminalText({required String line}){

      if(line.split(' ')[0] == CommandStatus.stdout.name){
        return TerminalText(text: line.substring(7), commandStatus: CommandStatus.stdout );
      }else if(line.split(' ')[0] == CommandStatus.stdinp.name){
        return (TerminalText(text: line.substring(7), commandStatus: CommandStatus.stdinp ));
      }
      return (TerminalText(text: line.substring(7), commandStatus:  CommandStatus.stderr));
  }

}