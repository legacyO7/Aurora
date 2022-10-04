import 'package:aurora/user_interface/terminal/domain/model/terminal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget arTerminal(TerminalText terminalText){

  Color _commandColor(CommandStatus commandStatus) {
    if (commandStatus == CommandStatus.stdin) {
      return Colors.blue;
    } else if (commandStatus == CommandStatus.stdout) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }


  return Text(terminalText.text,style: TextStyle(color: _commandColor(terminalText.commandStatus)));
}