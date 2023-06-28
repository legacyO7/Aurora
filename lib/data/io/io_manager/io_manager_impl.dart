import 'dart:io';

import 'io_manager.dart';


class IOManagerImpl implements IOManager{

  @override
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write}) async{
    try{
      if(filePath is String) {
        await File(filePath).writeAsString(content,mode: fileMode);
      }
      if(filePath is File) {
        await filePath.writeAsString(content,mode: fileMode);
      }
    }
    catch(_){}
  }

  @override
  Future<List<String>> readFile(dynamic filePath) async{

    try{
      if(filePath is String) {
        return await File(filePath).readAsLines();
      }
      if(filePath is File) {
        return await filePath.readAsLines();
      }
    }
    catch(e){
      return [];
    }

    return [];
  }

  @override
  Future<String> getFileStat(String filePath) async{
    return (await File(filePath).stat()).modeString();
  }

}