import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utility/terminal_text.dart';

class TerminalRepoImpl extends TerminalRepo{

  List<TerminalText> terminalOut = [];
  late Process process;
  bool _inProgress=false;
  bool _hasRootAccess=false;

  @override
  Stream<List<TerminalText>> execute(String command) async* {
    print(command);
    List<String> arguments=[];

    if (command == "clear") {

      terminalOut.clear();
      _inProgress=false;

      yield terminalOut;

      return;
    }else if(command.isNotEmpty) {
      arguments = command.split(' ');
      var exec=arguments[0];
      arguments.removeAt(0);
      _convertToList(line:  "\$ $command",commandStatus: CommandStatus.STDIN);

      try {

        if(_inProgress){
          process.stdin.writeln(command);
        }else {
         _inProgress=true;
         yield terminalOut;
          process = await Process.start(
              exec,
              arguments
          );
        }

        await for (var line in process.stdout) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.STDOUT);
        }

        await for (var line in process.stderr) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.STDERR);
        }

        _inProgress=false;
        yield terminalOut;

      } catch (e) {}
    }
  }

   _convertToList({required String line, CommandStatus? commandStatus}){
    if(commandStatus == CommandStatus.STDOUT){
      terminalOut.add(TerminalText(text: line, color: Colors.green ));
    }else if(commandStatus == CommandStatus.STDERR){
      terminalOut.add(TerminalText(text: line, color: Colors.red ));
    }else if(commandStatus == CommandStatus.STDIN){
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
  }

  @override
   killProcess(){
    try {
      process.kill();
    }catch(e){
      _convertToList(line: e.toString(),commandStatus: CommandStatus.STDERR);
    }
    finally{
      _convertToList(line: "process terminated",commandStatus: CommandStatus.STDERR);
      _inProgress=false;
    }
  }
  
  @override
  bool checkRootAccess()=> _hasRootAccess;

  @override
  bool isInProgress()=> _inProgress;
  
}