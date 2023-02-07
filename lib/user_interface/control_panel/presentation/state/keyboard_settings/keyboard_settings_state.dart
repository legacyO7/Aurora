import 'dart:ui';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class KeyboardSettingsState extends Equatable{
  final int brightness;
  final int mode;
  final int speed;
  final Color color;
  final bool boot;
  final bool awake;
  final bool sleep;

  const KeyboardSettingsState({
    this.brightness=0,
    this.mode=0,
    this.speed=0,
    this.color=ArColors.green,
    this.sleep=false,
    this.awake=false,
    this.boot=false
  });

  KeyboardSettingsState copyState({
    int? brightness,
    int? mode,
    int? speed,
    Color? color,
    bool? boot,
    bool? awake,
    bool? sleep
  }){
    return KeyboardSettingsState(
      color: color??this.color,
      mode: mode?? this.mode,
      brightness: brightness?? this.brightness,
      speed: speed?? this.speed,
      boot: boot?? this.boot,
      awake: awake?? this.awake,
      sleep: sleep??this.sleep
    );
  }

  @override
  List<Object?> get props => [brightness,speed,color,mode,boot,awake,sleep];

}
