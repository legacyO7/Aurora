import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utility/terminal_text.dart';

class TerminalRepoImpl extends TerminalRepo{

  List<TerminalText> terminalOut = [];
  late Process process;
  bool _inProgress=false;
  bool _hasRootAccess=false;

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
      _convertToList(line:  "\$ $command",commandStatus: CommandStatus.stdin);

       try{

        if(_inProgress){
          return;
        }else {
         _inProgress=true;
          process = await Process.start(
              exec,
              arguments
          );
        }

        await for (var line in process.stdout) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.stdout);
        }

        await for (var line in process.stderr) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.stderr);
        }

        _inProgress=false;
      } catch (e) {
        if (kDebugMode) {
          print("STDERR: ${e.toString()}");
        }
      }
    }
  }

   _convertToList({required String line, CommandStatus? commandStatus}){
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

    if(line.contains('Permission denied')){
      _hasRootAccess=false;
      terminalOut.clear();
    }else {
      _hasRootAccess=true;
    }
    _terminalSink.add(terminalOut);
   }

  @override
   killProcess(){
    try {
      process.kill();
    }catch(e){
      _convertToList(line: e.toString(),commandStatus: CommandStatus.stderr);
    }
    finally{
      _convertToList(line: "process terminated",commandStatus: CommandStatus.stderr);
      _inProgress=false;
    }
  }
  
  @override
  bool checkRootAccess()=> _hasRootAccess;

  @override
  bool isInProgress()=> _inProgress;

  @override
  Stream<List<TerminalText>> get terminalOutStream => _tStreamController.stream;

  
}