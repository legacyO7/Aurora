abstract class TerminalSource{
  Future execute(String command);
  killProcess();
  bool isInProgress();
  void disposeStream();
  Stream<String> get terminalOutStream;
}