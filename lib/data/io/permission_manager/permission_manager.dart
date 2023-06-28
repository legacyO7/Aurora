abstract class PermissionManager{
  Future runWithPrivileges(List<String> commands);
  Future<bool> validatePaths();
  Future setPermissions();
  Future<List<String>> listPackagesToInstall();
  List<String> get listMissingPackages;
}