import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget colorController(BuildContext context) {
  return  Column(
    children: [
      Text("Color Picker",style: Theme.of(context).textTheme.headlineSmall,),
      ColorPicker(
          wheelDiameter: 31.h<100?100:31.h,
          wheelWidth: 15,
          wheelHasBorder: true,
          color: context.selectedColor,
          wheelSquareBorderRadius: 20,
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: false,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.wheel: true,
          },
          onColorChanged: (color) =>
            context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetColor(color: color))
      ),
    ],
  );
}