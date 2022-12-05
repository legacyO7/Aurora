import 'dart:io';

import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';

mixin HomeMixin on HomeRepo{

  final TerminalRepo _terminalRepo=sl<TerminalRepo>();

  String  _packagesToInstall='';

  @override
  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput(command: "mokutil --sb-state")).toString().contains("enabled");
  }

  @override
  Future<bool> pkexecChecker() async{
    return (await _terminalRepo.getOutput(command: 'which pkexec')).length==2;
  }

  Future<String> listPackagesToInstall() async{
    var output=(await _terminalRepo.getOutput(command: "${Constants.globalConfig.kExecPermissionCheckerPath} checkpackages"));
    if(output.isEmpty||!output.last.contains('stdout')) {
      return '';
    }else{
      _packagesToInstall= output.last.split('stdout')[1].trim();
      return _packagesToInstall;
    }

  }

  @override
  Future<int> compatibilityChecker() async{

    if((await listPackagesToInstall()).isNotEmpty) {
      return 1;
    }

    if(!Directory(Constants.kFaustusModulePath).existsSync()) {
      if(File(Constants.kBatteryThresholdPath).existsSync() && systemHasSystemd()) {
        return 3;
      } else {
        return 2;
      }
    }

    if(!systemHasSystemd()) {
      return 4;
    }

    return 0;
  }


  @override
  int convertVersionToInt(String version) {
   return int.tryParse(version.replaceAll('.', '').replaceAll('+', '').split('-')[0])??0;
  }

  String get packagesToInstall=>_packagesToInstall;
  
}