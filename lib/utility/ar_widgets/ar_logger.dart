import 'dart:io';

import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/foundation.dart';

class ArLogger with GlobalMixin{

  ArLogger(this._ioManager);

  late File _logFile;
  final IOManager _ioManager;
  
  final List<String> _log=[];
  bool _logging=false;



  void log({required dynamic data, StackTrace? stackTrace}) {
    _log.add("$data\n ${stackTrace??''}");
    if(!_logging){
      _logging=true;
      _logBuffer(data: _log.first);
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
    Constants.globalConfig.setInstance(kTmpPath: Directory.systemTemp.path);
    _logFile=File("${Constants.globalConfig.kTmpPath}/ar.log");
    if(_logFile.existsSync()) {
      _logFile.deleteSync();
    }
  }
}