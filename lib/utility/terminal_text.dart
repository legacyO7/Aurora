import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


enum CommandStatus { STDERR, STDOUT, STDIN }

class TerminalText{
  String text;
  Color? color;

  TerminalText({required this.text,this.color});
}