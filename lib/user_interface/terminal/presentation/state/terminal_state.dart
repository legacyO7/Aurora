import 'package:aurora/utility/terminal_text.dart';

abstract class TerminalState{}

class TerminalStateInit extends TerminalState{
  TerminalStateInit();
}

class TerminalStateLoaded extends TerminalState{
  List<TerminalText> terminalOut;
  TerminalStateLoaded({required this.terminalOut});
}