import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int? brightness;

Widget brightnessController(BuildContext context) {
  return Row(
    children: [
      button(
          title: "Off",
          isSelected: brightness == 0,
          action: () {
            brightness = 0;
            context.read<HomeCubit>().setBrightness(brightness);
          }),
      button(
          title: "Low",
          isSelected: brightness == 1,
          action: () {
            brightness = 1;
            context.read<HomeCubit>().setBrightness(brightness);
          }),
      button(
          title: "Medium",
          isSelected: brightness == 2,
          action: () {
            brightness = 2;
            context.read<HomeCubit>().setBrightness(brightness);
          }),
      button(
          title: "High",
          isSelected: brightness == 3,
          action: () {
            brightness = 3;
            context.read<HomeCubit>().setBrightness(brightness);
          }),
    ],
  );
}
