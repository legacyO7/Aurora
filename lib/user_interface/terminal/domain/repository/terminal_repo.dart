import '../../../../utility/terminal_text.dart';

abstract class TerminalRepo{
  Future execute(String command);
  void killProcess();
  Future<bool> checkAccess();
  bool isInProgress();
  Stream<List<TerminalText>> get terminalOutStream;
  void disposeStream();
  Future<String> getOutput({required String input});
  clearTerminalOut();
}