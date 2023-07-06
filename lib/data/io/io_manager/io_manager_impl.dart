import 'dart:io';

import 'package:aurora/utility/ar_widgets/ar_logger.dart';

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
    FileSystemEntity fileInQuestion=await _parseFileSystemEntity(_parseFilePath(filePath));
    return (await fileInQuestion.exists() && (await fileInQuestion.stat()).type==fileType);
  }

  @override
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write, bool allowEmptyContent=false}) async{
    await ArLogger.arTry(() async{
      if(content.isNotEmpty||allowEmptyContent) {
        await File(_parseFilePath(filePath)).writeAsString(content,mode: fileMode);
      }else{
        stderr.writeln("blocked empty content from writing");
      }
    });
  }

  @override
  Future<List<String>> readFile(dynamic filePath) async{
    return await ArLogger.arTry(() async{
        if(await checkIfExists(filePath: filePath, fileType: FileSystemEntityType.file)){
          return await File(_parseFilePath(filePath)).readAsLines();
        }else{
          return [];
        }
    });

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