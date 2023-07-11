
abstract class HomeRepo {
  Future<bool> checkInternetAccess();

  bool checkFaustusFolder();

  Future launchArUrl({String? subPath});

  Future<String> getVersion();

  Future<int> compatibilityChecker();

  int convertVersionToInt(String version);

  void setAppHeight();

  Future<bool> requestAccess();

  Future<bool> canElevate();

  Future selfElevate();

  Future writeToFile({required String path, required String content});

  Future<bool> isDeviceCompatible();

  Future<bool> thresholdPathExists();

  Future<bool> systemHasSystemd();

  Future initLog();

  Future<int> enforceFaustus();
}