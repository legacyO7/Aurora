import 'dart:io';

abstract class IOManager {

  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write});
  Future<List<String>> readFile(dynamic filePath);
  Future<String> getFileStat(String filePath);
}