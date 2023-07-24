import 'package:aurora/utility/ar_widgets/cubits/color_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ArContextExt on BuildContext{
  Color get selectedColor=>  watch<ArColorCubit>().selectedColor;
  Color get selectedColorWithAlpha=>  watch<ArColorCubit>().selectedColorWithAlpha;
  Color get invertedColor=>  watch<ArColorCubit>().invertedColor;
}