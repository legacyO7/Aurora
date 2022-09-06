import 'dart:convert';
import 'dart:io';
import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utility/terminal_text.dart';
import '../../terminal/presentation/cubit/terminal_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeStateInit());

  List<TerminalText> terminalOut = [];
  late FocusNode tvFocus;
  late Process process;
  bool inProgress=false;

  streamer(String command) async {
    List<String> arguments=[];

    command=command.replaceAll("sudo", "pkexec");

    if (command == "clear") {

      terminalOut.clear();
      emit(HomeStateAccessGranted(terminalOp: terminalOut,inProgress: false));

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

          emit(HomeStateAccessGranted(terminalOp: terminalOut,inProgress: true));
          process = await Process.start(exec, arguments);
        }

        await for (var line in process.stdout) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.STDOUT);
        }

        await for (var line in process.stderr) {
          _convertToList(line: utf8.decode(line),commandStatus: CommandStatus.STDERR);
        }

        emit(HomeStateAccessGranted(terminalOp: terminalOut,inProgress: false));

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
    emit(HomeStateAccessGranted(terminalOp: terminalOut,inProgress: true));
  }

  void killProcess(){
    try {
      process.kill();
    }catch(e){
      _convertToList(line: e.toString(),commandStatus: CommandStatus.STDERR);
    }
    finally{
      _convertToList(line: "process terminated",commandStatus: CommandStatus.STDERR);
      emit(HomeStateAccessGranted(terminalOp: terminalOut,inProgress: false));
    }
  }

  void requestAccess(){
    streamer("sudo su");
  }

}