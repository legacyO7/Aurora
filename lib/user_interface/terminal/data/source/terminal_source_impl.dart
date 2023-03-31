import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class TerminalSourceImpl extends TerminalSource{

  late Process process;
  bool _inProgress=false;

  final Completer<int> completer = Completer<int>();
  final LineSplitter _lineSplitter=const LineSplitter();
  final _tStreamController = BehaviorSubject<String>();
  late Sink<String>  _terminalSink;

  final List<String> _commands=[];


  @override
  Future execute(String command) async{
    _commands.add(command.trim());
    if(!_inProgress){
      await _execute(_commands.first);
    }
  }


  Future _execute(String command) async {
    _terminalSink = _tStreamController.sink;
    List<String> arguments=[];

    if(command.isNotEmpty) {
      arguments = command.split(' ');
      var exec=arguments[0];
      arguments.removeAt(0);
      _convertToList(lines:  "\$ $command",commandStatus: CommandStatus.stdinp);

      try{

         _inProgress=true;
         process = await Process.start(
              exec,
              arguments,
              workingDirectory: Constants.globalConfig.kWorkingDirectory,
              runInShell: true,
              mode: ProcessStartMode.detachedWithStdio
          );

        getStdout();
        await getStdErr();

      } catch (e) {
        if (kDebugMode) {
          print("STDERR: ${e.toString()}");
        }else {
          await _logIt(e.toString());
        }
        _inProgress=false;
      }

      _commands.removeAt(0);
      if(_commands.isNotEmpty){
        await _execute(_commands.first);
      }else {
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
      }else {
        await _logIt(line);
      }
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
    File("${Constants.globalConfig.kTmpPath}/ar.log").writeAsString("> $value\n",mode: FileMode.append);
  }

  @override
  Future clearLog() async{
    var logFile=File("${Constants.globalConfig.kTmpPath}/ar.log");
    if(logFile.existsSync()) {
      logFile.deleteSync();
    }
  }
}