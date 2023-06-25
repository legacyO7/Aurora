abstract class PermissionManager{
  Future<bool> validatePaths();
  Future setPermissions();
  Future<List<String>> listPackagesToInstall();
  List<String> get listMissingPackages;
}