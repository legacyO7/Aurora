import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TerminalBaseBloc<Event,State> extends Bloc<Event,State> {

  TerminalBaseBloc(State initialState) : super(initialState);

  final TerminalRepo _terminalRepo = sl<TerminalRepo>();

  Future execute(String command) async {
    return await _terminalRepo.execute(command);
  }

  Future<bool> checkAccess() async {
    return await _terminalRepo.checkAccess();
  }

  void killProcess() {
    _terminalRepo.killProcess();
  }

  void clearTerminalOutput(){
    _terminalRepo.clearTerminalOut();
  }

  Future<List<String>> getOutput({required String command}) async{
    return await _terminalRepo.getOutput(command: command);
  }

  List<String> cleanTerminalOut(List<String> text){
   for (var element in text) {
     element=element.split(' ')[1];
   }
   return text;
  }

  void dispose(){
    _terminalRepo.disposeStream();
  }

  Stream<List<String>> get terminalOutput => _terminalRepo.terminalOutStream;



}