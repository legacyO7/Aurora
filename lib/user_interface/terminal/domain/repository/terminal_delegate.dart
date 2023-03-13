abstract class TerminalDelegate {

  Future<String> extractAsset({required String sourceFileName});
  Future execute(String command);
  Future<bool> checkAccess();
  Future<List<String>> getOutput({required String command});
  Future<bool> isSecureBootEnabled();
  Future<bool> pkexecChecker();
  Future<bool> isKernelCompatible();
  Future<String> listPackagesToInstall();
  String get listMissingPackages;

}