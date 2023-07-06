import 'dart:io';

import 'package:aurora/data/init_aurora.dart';
import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/foundation.dart';


class ArLogger with GlobalMixin{

  static ArLogger? _instance;

  ArLogger._();

  factory ArLogger(){
    _instance??=ArLogger._();
    return _instance!;
  }

  late File _logFile;
  final IOManager _ioManager=sl<IOManager>();
  
  final List<String> _log=[];
  bool _logging=false;

  static T arTry<T>(T Function() tryBlock) {
    try {
      return tryBlock();
    } catch (error, stackTrace) {
      _instance!.log(data: error,stackTrace: stackTrace);
    }
    throw ('error');
  }

  Future log({required dynamic data, StackTrace? stackTrace})async {
    if(canLog()) {
      _log.add("$data\n ${stackTrace ?? ''}");
      if (!_logging) {
        _logging = true;
        await _logBuffer(data: _log.first);
      }
    }
  }

  Future _logBuffer({required String data}) async{
    if (kDebugMode) {
      print(data.trim());
    }else {
      await _ioManager.writeToFile(
          filePath: _logFile,
          content: data,
          fileMode: FileMode.append);
    }

    _log.removeAt(0);
    if(_log.isNotEmpty){
      await _logBuffer(data: _log.first);
    }else{
      _logging=false;
    }
  }

  void initialize(){
    try{
    Constants.globalConfig.setInstance(kTmpPath: Directory.systemTemp.path);
    _logFile=File("${Constants.globalConfig.kTmpPath}/ar.log");
    if(_logFile.existsSync()) {
      _logFile.deleteSync();
      }
    }catch(_){}
  }
}