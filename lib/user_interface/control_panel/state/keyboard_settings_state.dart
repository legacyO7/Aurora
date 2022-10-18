import 'dart:ui';
import 'package:aurora/utility/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class KeyboardSettingsState extends Equatable{
  final int brightness;
  final int mode;
  final int speed;
  final Color color;

  const KeyboardSettingsState({
    this.brightness=0,
    this.mode=0,
    this.speed=0,
    this.color=ArColors.green
  });

  KeyboardSettingsState copyState({
    int? brightness,
    int? mode,
    int? speed,
    Color? color
  }){
    return KeyboardSettingsState(
      color: color??this.color,
      mode: mode?? this.mode,
      brightness: brightness?? this.brightness,
      speed: speed?? this.speed
    );
  }

  @override
  List<Object?> get props => [brightness,speed,color,mode];

}
