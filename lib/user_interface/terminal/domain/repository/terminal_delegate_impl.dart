import 'dart:io';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';

class TerminalDelegateImpl implements TerminalDelegate {


  TerminalDelegateImpl(this._terminalSource,this._terminalRepo);

  final TerminalSource _terminalSource;
  final TerminalRepo _terminalRepo;
  
  String  _packagesToInstall='';

  @override
  Future<String> extractAsset({required String sourceFileName}) async {
    final byteData = await rootBundle.load('${Constants.kAssetsPath}/$sourceFileName');
    var destinationFileName = "${Constants.globalConfig.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await _terminalSource.execute("chmod +x $destinationFileName");
    return destinationFileName;
  }

  @override
  Future execute(String command) async {
    return await _terminalSource.execute(command);
  }

  @override
  Future<bool> checkAccess() async {
    return await _terminalRepo.checkAccess();
  }


  @override
  Future<List<String>> getOutput({required String command}) async{
    return await _terminalRepo.getOutput(command: command);
  }

  @override
  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput(command: "mokutil --sb-state")).toString().contains("enabled");
  }

  @override
  Future<bool> pkexecChecker() async{
    return (await _terminalRepo.getOutput(command: 'command -v pkexec')).length==1;
  }

  @override
  Future<String> listPackagesToInstall() async{
    var output=(await _terminalRepo.getOutput(command: "${Constants.globalConfig.kExecPermissionCheckerPath} checkpackages"));
    if(output.isEmpty) {
      return '';
    }else{
      _packagesToInstall= output.last.trim();
      return _packagesToInstall;
    }
  }

  @override
  Future<bool> isKernelCompatible() async{
    return (await _terminalRepo.getOutput(command: 'uname -r')).last.startsWith("6.1");
  }
  
  @override
  String get listMissingPackages=>_packagesToInstall;

}