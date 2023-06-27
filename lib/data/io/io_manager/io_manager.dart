import 'dart:io';

abstract class IOManager {

  Future writeToFile({required String filePath, required String content, FileMode fileMode=FileMode.write});
  Future<List<String>> readFile(String filePath);
  Future<String> getFileStat(String filePath);
}