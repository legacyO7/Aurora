
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_event.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';

import 'terminal_state.dart';

class TerminalBloc extends TerminalBaseBloc<TerminalEvent,TerminalState>{
  TerminalBloc():super(TerminalStateInit()){
   on<TerminalEventListen>((event, emit) => _listenToTerminal(emit,output: event.output));
   on<TerminalEventKill>((_, __) => _killCurrentProcess());
   on<TerminalEventDispose>((_, __) => _dispose());
   _initTerminal();
  }

  void _initTerminal() async{
    super.terminalOutput.listen((event) {
     add(TerminalEventListen(output: event));
    });
  }

  void _listenToTerminal(emit,{required List<String> output}) async{
    emit(TerminalStateLoaded(terminalOut: output));
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