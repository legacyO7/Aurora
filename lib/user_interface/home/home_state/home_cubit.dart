import 'dart:convert';
import 'dart:io';

import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utility/terminal_text.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeStateInit());

  List<TerminalText> terminalOut = [];
  late Process process;
  bool inProgress=false;
  bool hasRootAccess=false;

  Color _selectedColor=Colors.green;

  execute(String command) async {
    List<String> arguments=[];

    if (command == "clear") {

      terminalOut.clear();
      _writeOut(op: terminalOut, inProgress: false);

      return;
    }else if(command.isNotEmpty) {
      arguments = command.split(' ');
      var exec=arguments[0];
      arguments.removeAt(0);

      _convertToList(line:  "\$ $command",commandStatus: CommandStatus.STDIN);
      try {

        if(inProgress){
          process.stdin.writeln(command);
        }else {
          _writeOut(op: terminalOut, inProgress: true);
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

        _writeOut(op: terminalOut, inProgress: false);

      } catch (e) {}
    }
  }

  void _convertToList({required String line, CommandStatus? commandStatus}){
    if(commandStatus == CommandStatus.STDOUT){
      terminalOut.add(TerminalText(text: line, color: Colors.green ));
    }else if(commandStatus == CommandStatus.STDERR){
      terminalOut.add(TerminalText(text: line, color: Colors.red ));
    }else if(commandStatus == CommandStatus.STDIN){
      terminalOut.add(TerminalText(text: line, color: Colors.blue ));
    }

    if(line.contains('Permission denied')){
      hasRootAccess=false;
      terminalOut.clear();
    }else {
      hasRootAccess=true;
    }

    if (kDebugMode) {
      print("--- $line");
    }

    _writeOut(op: terminalOut, inProgress: true);
  }

  void killProcess(){
    try {
      process.kill();
    }catch(e){
      _convertToList(line: e.toString(),commandStatus: CommandStatus.STDERR);
    }
    finally{
      _convertToList(line: "process terminated",commandStatus: CommandStatus.STDERR);
      _writeOut(op: terminalOut, inProgress: false);
    }
  }

  void _writeOut({required List<TerminalText> op, required bool inProgress}){
    emit(AccessGranted(terminalOp: op,inProgress: inProgress,hasRootAccess: hasRootAccess));
  }

  void requestAccess(){
    execute("pkexec ${Directory.current.path}/assets/scripts/faustus_controller.sh");
  }

  setColor(color){
    _selectedColor= color;
    execute("${Directory.current.path}/assets/scripts/faustus_controller.sh color ${color.red.toRadixString(16)} ${color.green.toRadixString(16)} ${color.blue.toRadixString(16)} 0");
  }

  setBrightness(value){
    execute("${Directory.current.path}/assets/scripts/faustus_controller.sh brightness $value ");
  }

  Color get selectedColor => _selectedColor;
}