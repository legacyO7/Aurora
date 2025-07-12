abstract class ServiceManager{
  Future createService({String? serviceFilePath});
  String get createServiceContentByShell;
  Future updateService();
  Future deleteService();
}