import 'dart:io';

import 'constants.dart';
import 'global_configuration.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.arMode==ARMODE.mainline;

  bool systemHasSystemd() => Directory(Constants.kServicePath).existsSync();

  bool isMainLineCompatible()=>
      File(Constants.kMainlineModuleModePath).existsSync() &&
      File(Constants.kMainlineModuleStatePath).existsSync() &&
      File(Constants.kMainlineBrightnessPath).existsSync();

}