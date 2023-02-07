abstract class TerminalSource{
  Future execute(String command);
  killProcess();
  bool isInProgress();
  void disposeStream();
  Future clearLog();
  Stream<String> get terminalOutStream;
}