import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ArContextExt on BuildContext{
  Color get selectedColor=>  watch<KeyboardSettingsBloc>().selectedColor;
  Color get selectedColorWithAlpha=>  watch<KeyboardSettingsBloc>().selectedColor.withAlpha(50);
  Color get invertedColor=>  watch<KeyboardSettingsBloc>().invertedSelectedColor;
}