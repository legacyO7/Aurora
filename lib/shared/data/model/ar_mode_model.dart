import 'dart:ui';

import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:isar/isar.dart';

part 'ar_mode_model.g.dart';

@embedded
class ArMode{
  int? mode;
  int? speed;

  @ignore
  Color? color;
  int? colorRad;


  ArMode({this.mode, this.speed, this.color, this.colorRad});

  ArMode.fromJson(Map<String, dynamic> json){
    if(json.isEmpty) return;

    mode=json['mode'] as int;
    speed=json['speed'] as int;
    colorRad=int.parse((json['color']??ArColors.blue.toString()).split('(0x')[1].split(')')[0],radix: 16);
    color=Color(colorRad!);
  }
}