import 'package:aurora/user_interface/terminal/domain/model/terminal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget arTerminal(TerminalText terminalText){

  Color _commandColor(CommandStatus commandStatus) {
    if (commandStatus == CommandStatus.stdinp) {
      return ArColors.blue;
    } else if (commandStatus == CommandStatus.stdout) {
      return ArColors.green;
    } else {
      return ArColors.red;
    }
  }


  return Text(terminalText.text,style: TextStyle(color: _commandColor(terminalText.commandStatus)));
}