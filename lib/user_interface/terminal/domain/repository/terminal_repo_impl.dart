import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utility/terminal_text.dart';
import 'terminal_repo.dart';

class TerminalRepoImpl extends TerminalRepo{

  List<TerminalText> terminalOut = [];
  late Process process;
  bool _inProgress=false;
  bool _hasRootAccess=false;

  final LineSplitter _lineSplitter=const LineSplitter();

  final _tStreamController = BehaviorSubject<List<TerminalText>>();

  late Sink<List<TerminalText>>  _terminalSink;

  @override
  Future execute(String command) async {
    _terminalSink = _tStreamController.sink;
    List<String> arguments=[];

    if (command == "clear") {

      terminalOut.clear();
      _inProgress=false;

      _terminalSink.add(terminalOut);

      return;
    }else if(command.isNotEmpty) {
      arguments = command.split(' ');
      var exec=arguments[0];
      arguments.removeAt(0);
      _convertToList(lines:  "\$ $command",commandStatus: CommandStatus.stdin);

       try{

        if(_inProgress){
          return;
        }else {
         _inProgress=true;
          process = await Process.start(
              exec,
              arguments,
            workingDirectory: Constants.kWorkingDirectory
          );
        }

        await for (var line in process.stdout) {
          _convertToList(lines: utf8.decode(line),commandStatus: CommandStatus.stdout);
        }

        await for (var line in process.stderr) {
          _convertToList(lines: utf8.decode(line),commandStatus: CommandStatus.stderr);
        }

        _inProgress=false;
      } catch (e) {
        if (kDebugMode) {
          print("STDERR: ${e.toString()}");
        }
      }
    }
  }

   _convertToList({required String lines, CommandStatus? commandStatus}){
    _lineSplitter.convert(lines).forEach((line) {
      if(commandStatus == CommandStatus.stdout){
        terminalOut.add(TerminalText(text: line, color: Colors.green ));
      }else if(commandStatus == CommandStatus.stderr){
        terminalOut.add(TerminalText(text: line, color: Colors.red ));
      }else if(commandStatus == CommandStatus.stdin){
        terminalOut.add(TerminalText(text: line, color: Colors.blue ));
      }

      if (kDebugMode) {
        print("--- $line");
      }

    });
    _terminalSink.add(terminalOut);
   }

  @override
  Future<bool> checkAccess() async{
    terminalOut.clear();
    await execute("${Constants.kExecFaustusPath} save");
    _hasRootAccess=false;
    for (int i =0;i<terminalOut.length;i++) {
      if(terminalOut[i].text.contains('faustus_controller.sh save')&&i+1<terminalOut.length){
        if(!terminalOut[i+1].text.contains('Permission denied')){
          _hasRootAccess=true;
          terminalOut.clear();
        }
      }
    }

    return _hasRootAccess;
  }

  @override
   killProcess(){
    try {
      process.kill();
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
  Stream<List<TerminalText>> get terminalOutStream => _tStreamController.stream;

  @override
  void disposeStream(){
    _tStreamController.close();
  }
  
}