
abstract class TerminalState{}

class TerminalStateInit extends TerminalState{
  TerminalStateInit();
}

class TerminalStateLoaded extends TerminalState{
  List<String> terminalOut;
  TerminalStateLoaded({required this.terminalOut});
}