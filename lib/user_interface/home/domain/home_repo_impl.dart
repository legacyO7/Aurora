import 'dart:io';

import 'package:aurora/user_interface/home/domain/home_mixin.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with HomeMixin{

  HomeRepoImpl(this._terminalSource);

  final TerminalSource _terminalSource;

  @override
  Future<String> extractAsset({required String sourceFileName}) async {
    final byteData = await rootBundle.load('${Constants.kAssetsPath}/$sourceFileName');
    var destinationFileName = "${Constants.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await _terminalSource.execute("chmod +x $destinationFileName");
    return destinationFileName;
  }

  @override
  List<String> readFile({required String path}){
    return (File(path).readAsLinesSync());
  }

}