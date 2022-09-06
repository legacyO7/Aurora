import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget brightnessController(BuildContext context){
  return Row(
    children: [
      button(title: "Off", action: ()=> context.read<HomeCubit>().setBrightness(0)),
      button(title: "Low", action: ()=> context.read<HomeCubit>().setBrightness(1)),
      button(title: "Medium", action: ()=> context.read<HomeCubit>().setBrightness(2)),
      button(title: "High", action: ()=> context.read<HomeCubit>().setBrightness(3)),
    ],
  );
}




