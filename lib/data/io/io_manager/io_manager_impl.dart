import 'dart:io';

import 'io_manager.dart';


class IOManagerImpl implements IOManager{

  @override
  Future createFileSystemEntity({required String path, FileSystemEntityType fileType=FileSystemEntityType.file}) async{
    switch(fileType){
      case FileSystemEntityType.directory:
        await Directory(path).create();
        break;
      case FileSystemEntityType.file:
        await File(path).create();
        break;
      default:
        stderr.writeln("unhandled filetype $fileType");
    }
  }

  @override
  Future<bool> checkIfExists({required dynamic filePath, required FileSystemEntityType fileType}) async{
    FileSystemEntity fileInQuestion=await _parseFileSystemEntity(filePath);
    return (await fileInQuestion.exists() && (await fileInQuestion.stat()).type==fileType);
  }

  @override
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write}) async{
    try{
      await File(_parseFilePath(filePath)).writeAsString(content,mode: fileMode);
    }
    catch(_){}
  }

  @override
  Future<List<String>> readFile(dynamic filePath) async{
    try{
        if(await checkIfExists(filePath: filePath, fileType: FileSystemEntityType.file)){
          return File(_parseFilePath(filePath)).readAsLines();
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

  String _parseFilePath(dynamic filePath){
    if(filePath is String) {
      return filePath;
    }
    if(filePath is FileSystemEntity) {
      return filePath.path;
    }

    throw ("I donno what that is");
  }

  Future<FileSystemEntity> _parseFileSystemEntity(String filePath) async =>
     await FileSystemEntity.isDirectory(filePath)? Directory(filePath):File(filePath);


}