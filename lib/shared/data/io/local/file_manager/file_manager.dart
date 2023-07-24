
abstract class FileManager{
  void setWorkingDirectory();
  Future<bool> isDeviceCompatible();
  Future<bool> thresholdPathExists();
  Future<List<String>> searchTextFilesInDirectory({required List<String> searchText, required String directoryPath, bool searchSubDirectories=false});
  Future replaceTextInFile(String path,{required String which, required String withWhat});
}