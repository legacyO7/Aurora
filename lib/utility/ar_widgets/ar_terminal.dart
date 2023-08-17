
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ar_enums.dart';

Widget arTerminal(TerminalText terminalText){

  Color commandColor(CommandStatus commandStatus) {
    if (commandStatus == CommandStatus.stdinp) {
      return ArColors.blue;
    } else if (commandStatus == CommandStatus.stdout) {
      return ArColors.green;
    } else {
      return ArColors.red;
    }
  }


  return Text(terminalText.text,style: TextStyle(color: commandColor(terminalText.commandStatus)));
}