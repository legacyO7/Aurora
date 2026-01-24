import 'package:flutter/material.dart';

class ArColors {
  static Color accentColor = green;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color purple = Colors.purple;
  static const Color purpleLight = Colors.pinkAccent;
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  static const Color pink = Colors.pink;
  static const Color orange = Colors.orange;
  static const Color yellow = Colors.yellow;
  static const Color purpleDark = Colors.deepPurple;
  static const Color blue = Colors.blue;
  static const Color cyan = Colors.cyan;
  static Color? greyDisabled = Colors.grey[600];
  static const Color green = Colors.green;
  static const Color dialogBarrierColor = Colors.black54;
  static const Color transparent = Colors.transparent;
}

extension ArColorExt on Color {
  int get toRed => (r * 255.0).round();
  int get toGreen => (g * 255.0).round();
  int get toBlue => (b * 255.0).round();
  int get toAlpha => (a * 255.0).round();

}
