import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/terminal_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TerminalBaseCubit<State> extends BlocBase<State> {

  TerminalBaseCubit(State initialState) : super(initialState);

  final TerminalRepo _terminalRepo = sl<TerminalRepo>();

  Future execute(String command) async {
    await _terminalRepo.execute(command);
  }

  Future<bool> checkAccess() async {
    return await _terminalRepo.checkAccess();
  }

  void killProcess() {
    _terminalRepo.killProcess();
  }

  Stream<List<TerminalText>> get terminalOutput => _terminalRepo.terminalOutStream;


}