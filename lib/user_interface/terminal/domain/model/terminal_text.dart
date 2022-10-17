


enum CommandStatus { stderr, stdout, stdinp }

class TerminalText{
  String text;
  CommandStatus commandStatus;

  TerminalText({required this.text,required this.commandStatus});

}