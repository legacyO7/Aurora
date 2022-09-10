import '../../../../utility/terminal_text.dart';

abstract class TerminalRepo{
  Future execute(String command);
  void killProcess();
  bool checkRootAccess();
  bool isInProgress();
  Stream<List<TerminalText>> get terminalOutStream;
}