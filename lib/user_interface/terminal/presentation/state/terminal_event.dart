abstract class TerminalEvent{}

class TerminalEventListen implements TerminalEvent{
  List<String> output;
  TerminalEventListen({required this.output});
}

class TerminalEventKill implements TerminalEvent{}

class TerminalEventDispose implements TerminalEvent{}