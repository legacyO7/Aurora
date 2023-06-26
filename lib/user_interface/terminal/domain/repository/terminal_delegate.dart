abstract class TerminalDelegate {

  Future<String> extractAsset({required String sourceFileName});
  Future execute(String command);
  Future<List<String>> getOutput({required String command});
  Future<bool> isSecureBootEnabled();
  Future<bool> pkexecChecker();
  Future<bool> isKernelCompatible();
  Future<bool> arServiceEnabled();
}