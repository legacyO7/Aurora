abstract class PermissionManager{
  Future<int> runWithPrivileges(List<String> commands);
  Future<bool> validatePaths();
  Future<bool> hasPermission(String path);
  Future<String> getPermission(String path);
  Future<int> setPermissions();
  Future<List<String>> listPackagesToInstall();
  List<String> get listMissingPackages;
  List<String> get deniedList;
}