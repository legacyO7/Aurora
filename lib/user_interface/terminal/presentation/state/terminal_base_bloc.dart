import 'package:aurora/utility/warmup.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TerminalBaseBloc<Event,State> extends Bloc<Event,State> with GlobalMixin{

  TerminalBaseBloc(State initialState) : super(initialState);

  final TerminalRepo _terminalRepo = sl<TerminalRepo>();

  void killProcess() {
    _terminalRepo.killProcess();
  }

  void clearTerminalOutput(){
    _terminalRepo.clearTerminalOut();
  }

  void dispose(){
    _terminalRepo.disposeStream();
  }

  Stream<List<String>> get terminalOutput => _terminalRepo.terminalOutStream;

}