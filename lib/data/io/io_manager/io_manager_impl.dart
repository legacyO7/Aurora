import 'dart:io';

import 'io_manager.dart';


class IOManagerImpl implements IOManager{

  @override
  Future<bool> checkIfExists({required dynamic filePath, required FileSystemEntityType fileType}) async{
    File fileInQuestion=_convertPathToFile(filePath);
    return (await fileInQuestion.exists() && (await fileInQuestion.stat()).type==fileType);
  }

  @override
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write}) async{
    try{
      await _convertPathToFile(filePath).writeAsString(content,mode: fileMode);
    }
    catch(_){}
  }

  @override
  Future<List<String>> readFile(dynamic filePath) async{
    try{
        if(await checkIfExists(filePath: filePath, fileType: FileSystemEntityType.file)){
          return await _convertPathToFile(filePath).readAsLines();
        }else{
          return [];
        }
    }
    catch(e){
      return [];
    }
  }

  @override
  Future<String> getFileStat(String filePath) async{
    return (await File(filePath).stat()).modeString();
  }

  File _convertPathToFile(dynamic filePath){
    if(filePath is String) {
      return File(filePath);
    }
    if(filePath is File) {
      return filePath;
    }

    throw ("I donno what that is");
  }


}