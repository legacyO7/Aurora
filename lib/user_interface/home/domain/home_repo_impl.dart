import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo{

  HomeRepoImpl(this._terminalRepo);

  final TerminalRepo _terminalRepo;

  @override
  Future<String> extractAsset({required String sourceFileName}) async {
    final byteData = await rootBundle.load('${Constants.kAssetsPath}/$sourceFileName');
    var destinationFileName = "${Constants.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await _terminalRepo.execute("chmod +x $destinationFileName");
    return destinationFileName;
  }

  @override
  List<String> readFile({required String path}){
    return (File(path).readAsLinesSync());
  }
  
  @override
  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput(input: "mokutil --sb-state")).contains("enabled");
  }

}