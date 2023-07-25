
abstract class FileManager{
  Future setWorkingDirectory();
  Future<bool> isDeviceCompatible();
  Future<bool> thresholdPathExists();
  Future<List<String>> searchTextFilesInDirectory({required List<String> searchText, required String directoryPath, bool searchSubDirectories=false});
  Future replaceTextInFile(String path,{required String which, required String withWhat});
  Future releaseTmpWorkingDir();
  Future setTmpWorkingDir();
}