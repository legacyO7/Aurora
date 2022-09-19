import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget colorController(BuildContext context) {
  return  ColorPicker(
      wheelDiameter: 210,
      wheelWidth: 20,
      wheelHasBorder: true,
      color: context.read<KeyboardSettingsCubit>().selectedColor,
      wheelSquareBorderRadius: 10,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      colorCodeHasColor: false,
      onColorChanged: (color) async{
        context.read<KeyboardSettingsCubit>()
          ..setColor(color)
          ..setMode(0);
      });
}