abstract class SetupRepo{
  Future<String> getTerminalList();
  Future<String> getAuroraLiveVersion();
  Future<String> getChangelog();
  Future initSetup();
  Future loadSetupFiles();
  Future<bool> pkexecChecker();
  Future installPackages();
  Future installFaustus();
  List<String> get missingPackagesList;
}