
import 'dart:io';

import 'package:args/args.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';

class ArArgsParser with GlobalMixin{

   Future initParser(List<String> args) async{
    var parser = ArgParser();
    parser..addFlag('log',defaultsTo: false)
      ..addFlag('version')
      ..addOption('profile');
    ArgResults? result;
    try {
      result = parser.parse(args);
    }catch(e,stackTrace){
      stdout.writeln("unknown argument");
      ArLogger.log(data: e,stackTrace: stackTrace);
      exit(0);
    }
    await validateArgs(result);
  }


  Future validateArgs(ArgResults results) async{

    List<String> cliArgs=['version'];
    List<String> appArgs=['log'];

    Map<String, Function> argExecutables={
      'version': () async => stdout.writeln(await getVersion()),
      'log': () => Constants.globalConfig.isLoggingEnabled=results.wasParsed('log'),
    };


    for (var arg in [...cliArgs,...appArgs]){
      if(results.wasParsed(arg)){
        await argExecutables[arg]!.call();
      }
    }

    if(results.arguments.isNotEmpty&&(!results.arguments.any((element) => appArgs.contains(element.replaceAll('-', ''))))){
      exit(0);
    }

  }
}