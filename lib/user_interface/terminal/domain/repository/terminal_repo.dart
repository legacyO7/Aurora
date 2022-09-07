import '../../../../utility/terminal_text.dart';

abstract class TerminalRepo{
  Stream<List<TerminalText>> execute(String command);
  void killProcess();
  bool checkRootAccess();
  bool isInProgress();
}