import 'dart:ui';

import 'package:aurora/utility/ar_widgets/colors.dart';

class ArMode{
  int? mode;
  int? speed;
  Color? color;


  ArMode({this.mode, this.speed, this.color});

  ArMode.fromJson(Map<String, dynamic> json){
    if(json.isEmpty) return;

    mode=json['mode'] as int;
    speed=json['speed'] as int;
    color=Color(int.parse((json['color']??ArColors.blue.toString()).split('(0x')[1].split(')')[0],radix: 16));
  }
}