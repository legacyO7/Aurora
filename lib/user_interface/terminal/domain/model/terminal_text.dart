


enum CommandStatus { stderr, stdout, stdin }

class TerminalText{
  String text;
  CommandStatus commandStatus;

  TerminalText({required this.text,required this.commandStatus});

}