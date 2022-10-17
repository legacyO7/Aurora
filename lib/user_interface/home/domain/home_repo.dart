

abstract class HomeRepo{
  Future<String> extractAsset({required String sourceFileName});
  List<String?> readFile({required String path});
  Future<bool> isSecureBootEnabled();
  Future<bool> checkInternetAccess();
  Future launchArUrl({String? subPath});
  Future<String> getVersion();
  bool compatibilityChecker();
  Future<int> getBatteryCharge();
  int convertVersionToInt(String version);
}