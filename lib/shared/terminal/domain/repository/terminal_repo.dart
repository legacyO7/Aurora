

abstract class TerminalRepo{
  Future execute(String command);
  void killProcess();
  bool isInProgress();
  Stream<List<String>> get terminalOutStream;
  void disposeStream();
  Future<List<String>> getOutput(String command);
  Future<int> getStatusCode(String command);
  void clearTerminalOut();
}