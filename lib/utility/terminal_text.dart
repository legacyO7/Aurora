import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


enum CommandStatus { stderr, stdout, stdin }

class TerminalText{
  String text;
  Color? color;

  TerminalText({required this.text,this.color});
}