import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';

import '../data/di/di.dart';
import 'constants.dart';
import 'global_configuration.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.arMode==ARMODE.mainline;

  bool isMainLineCompatible()=>
      File(Constants.kMainlineModuleModePath).existsSync() &&
      File(Constants.kMainlineModuleStatePath).existsSync() &&
      File(Constants.kMainlineBrightnessPath).existsSync();

  Future<bool> arServiceEnabled() async{
    return (await sl<TerminalRepo>().getOutput(command: Constants.kArServiceStatus))
        .toString().contains('aurora-controller.service; enabled');

  }

}