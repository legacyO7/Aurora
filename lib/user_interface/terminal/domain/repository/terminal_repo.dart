

abstract class TerminalRepo{
  Future execute(String command);
  void killProcess();
  Future<bool> checkAccess();
  bool isInProgress();
  Stream<List<String>> get terminalOutStream;
  void disposeStream();
  Future<List<String>> getOutput({required String command});
  void clearTerminalOut();
}