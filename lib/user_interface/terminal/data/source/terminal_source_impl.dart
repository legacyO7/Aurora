import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/user_interface/terminal/domain/model/terminal_text.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class TerminalSourceImpl extends TerminalSource{

  late Process process;
  bool _inProgress=false;

  final Completer<int> completer = Completer<int>();
  final LineSplitter _lineSplitter=const LineSplitter();
  final _tStreamController = BehaviorSubject<String>();
  late Sink<String>  _terminalSink;

  @override
  Future execute(String command) async {
    _terminalSink = _tStreamController.sink;
    List<String> arguments=[];

    if(command.isNotEmpty) {
      arguments = command.split(' ');
      var exec=arguments[0];
      arguments.removeAt(0);
      _convertToList(lines:  "\$ $command",commandStatus: CommandStatus.stdinp);

      try{

        if(_inProgress){
            return;
        }else {
          _inProgress=true;
         process = await Process.start(
              exec,
              arguments,
              workingDirectory: Constants.globalConfig.kWorkingDirectory
          );
        }

        getStdout();
        await getStdErr();

        _inProgress=false;

      } catch (e) {
        if (kDebugMode) {
          print("STDERR: ${e.toString()}");
        }
        await _logIt(e.toString());
        _inProgress=false;
      }
    }
  }

  getStdout() async{
    await for (var line in process.stdout) {
      _convertToList(lines: utf8.decode(line),commandStatus: CommandStatus.stdout);
    }
  }

  getStdErr() async{
    await for (var line in process.stderr) {
      _convertToList(lines: utf8.decode(line),commandStatus: CommandStatus.stderr);
    }
  }

  _convertToList({required String lines, required CommandStatus commandStatus}){
    _lineSplitter.convert(lines).forEach((line) async{
      if (kDebugMode) {
        print("> ${commandStatus.name} $line");
      }
      await _logIt(line);
      _terminalSink.add("${commandStatus.name} $line");

    });
  }


  @override
  killProcess(){
    try {
      if(_inProgress) {
        process.kill();
      }
    }catch(e){
      _convertToList(lines: e.toString(),commandStatus: CommandStatus.stderr);
    }
    finally{
      _convertToList(lines: "process terminated",commandStatus: CommandStatus.stderr);
      _inProgress=false;
    }
  }

  @override
  bool isInProgress()=> _inProgress;

  @override
  Stream<String> get terminalOutStream => _tStreamController.stream;

  @override
  void disposeStream(){
    _tStreamController.close();
    _terminalSink.close();
  }

  _logIt(String value) async{
    File("${(await getTemporaryDirectory()).path}/ar.log").writeAsString("> $value\n",mode: FileMode.append);
  }

  @override
  Future clearLog() async{
    File("${(await getTemporaryDirectory()).path}/ar.log").deleteSync();
  }
}