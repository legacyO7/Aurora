
abstract class HomeRepo{
  Future<String> extractAsset({required String sourceFileName});
  List<String?> readFile({required String path});
  Future<bool> isSecureBootEnabled();
  Future<bool> checkInternetAccess();
  bool checkFaustusFolder();
  Future launchArUrl({String? subPath});
  Future<String> getVersion();
  Future<int> compatibilityChecker();
  Future<bool> pkexecChecker();
  int convertVersionToInt(String version);
  String get packagesToInstall;
}