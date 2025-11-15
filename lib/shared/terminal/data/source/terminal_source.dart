abstract class TerminalSource{
  Future execute(String command);
  Future<List<String>> getOutput(String command);
  void killProcess();
  bool isInProgress();
  void disposeStream();
  Stream<String> get terminalOutStream;
}