
abstract class HomeRepo{
  List<String?> readFile({required String path});
  Future<bool> checkInternetAccess();
  bool checkFaustusFolder();
  Future launchArUrl({String? subPath});
  Future<String> getVersion();
  Future<int> compatibilityChecker();
  int convertVersionToInt(String version);
  void setAppHeight();
  Future loadScripts();
  Future<bool> requestAccess();
}