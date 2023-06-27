import 'dart:io';

import 'io_manager.dart';


class IOManagerImpl implements IOManager{

  @override
  Future writeToFile({required String filePath, required String content, FileMode fileMode=FileMode.write}) async{
    await File(filePath).writeAsString(content,mode: fileMode);
  }

  @override
  Future<List<String>> readFile(String filePath) async{
    return await File(filePath).readAsLines();
  }

  @override
  Future<String> getFileStat(String filePath) async{
    return (await File(filePath).stat()).modeString();
  }

}