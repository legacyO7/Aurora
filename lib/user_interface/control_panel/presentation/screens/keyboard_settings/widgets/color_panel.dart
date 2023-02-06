import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_event.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget colorController(BuildContext context) {
  return  ColorPicker(
      wheelDiameter: 210,
      wheelWidth: 20,
      wheelHasBorder: true,
      color: context.selectedColor,
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
        context.read<KeyboardSettingsBloc>()
            ..add(KeyboardSettingsEventSetColor(color: color))
            ..add(KeyboardSettingsEventSetMode());
      });
}