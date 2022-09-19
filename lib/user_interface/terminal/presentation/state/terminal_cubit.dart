import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'terminal_state.dart';

class TerminalCubit extends Cubit<TerminalState>{
  TerminalCubit(this._terminalRepo):super(TerminalStateInit());

  final TerminalRepo _terminalRepo;

  void killProcess(){
    _terminalRepo.killProcess();
  }

}