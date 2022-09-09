import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/home_state/home_cubit.dart';

Widget colorController(BuildContext context) {
  return  ColorPicker(
      wheelDiameter: 210,
      wheelWidth: 20,
      wheelHasBorder: true,
      color: context.read<ControlPanelCubit>().selectedColor,
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
        await context.read<HomeCubit>().setColor(color).then((value) => {
        if(value) {
            context.read<ControlPanelCubit>()
              ..setColor(color)
              ..setMode(0)
          }
        });
      });
}