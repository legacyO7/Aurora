import 'dart:io';

import 'package:aurora/utility/constants.dart';
import 'package:flutter/foundation.dart';

class ArLogger{

  late File _logFile;

  void log({required dynamic data, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print("$data");
    }else {
      _logFile.writeAsStringSync("$data\n ${stackTrace??''}",
          mode: FileMode.append);
    }
  }

  void initialize() {
    Constants.globalConfig.setInstance(kTmpPath: Directory.systemTemp.path);
    _logFile=File("${Constants.globalConfig.kTmpPath}/ar.log");
    if(_logFile.existsSync()) {
      _logFile.deleteSync();
    }
  }
}