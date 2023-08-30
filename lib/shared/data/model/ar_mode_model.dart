
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

part 'ar_mode_model.g.dart';

@Embedded(inheritance: false)
//ignore: must_be_immutable
class ArMode extends Equatable {
   int? mode;
   int? speed;

  @ignore
   Color? color;
   int? colorRad;


   ArMode({this.mode, this.speed, this.color, this.colorRad});

  factory ArMode.copyModel(ArMode model)=>
      ArMode(
        mode: model.mode,
        speed: model.speed,
        color: model.color,
        colorRad: model.colorRad?? model.color!.value
      );

  @override
  @ignore
  List<Object?> get props => [mode, speed, colorRad];

}