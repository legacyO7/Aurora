abstract class ServiceManager{
  Future createService({String? serviceFilePath});
  Future<String> get createServiceContentByShell;
  Future updateService();
  Future deleteService();
}