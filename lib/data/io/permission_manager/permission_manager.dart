abstract class PermissionManager{
  Future<int> runWithPrivileges(List<String> commands);
  Future<bool> validatePaths();
  Future<int> setPermissions();
  Future<List<String>> listPackagesToInstall();
  List<String> get listMissingPackages;
  List<String> get deniedList;
}