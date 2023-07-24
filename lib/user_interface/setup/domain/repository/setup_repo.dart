abstract class SetupRepo{
  Future<bool> checkInternetAccess();
  Future<int> compatibilityChecker();
  bool checkFaustusFolder();
  int convertVersionToInt(String version);
  Future<String> getTerminalList();
  Future<String> getAuroraLiveVersion();
  Future<String> getChangelog();
  Future initSetup();
  Future loadSetupFiles();
  Future<bool> pkexecChecker();
  Future installPackages();
  Future installFaustus();
  Future<bool> isFaustusEnforced();
  Future<bool> checkIfBlackListed();
  List<String> get missingPackagesList;
  List<String> get blacklistedConfs;
}