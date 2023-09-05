import 'dart:io';

abstract class IOManager {
  Future createFileSystemEntity({required String path, FileSystemEntityType fileType=FileSystemEntityType.file});
  Future<bool> checkIfExists({required dynamic filePath, required FileSystemEntityType fileType});
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write});
  Future<List<String>> readFile(dynamic filePath);
  Future<String> getFileStat(String filePath);
  Future deleteFile(File file);
}