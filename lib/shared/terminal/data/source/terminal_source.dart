abstract class TerminalSource{
  Future execute(String command);
  Future<List<String>> getOutput(String command);
  killProcess();
  bool isInProgress();
  void disposeStream();
  Stream<String> get terminalOutStream;
}