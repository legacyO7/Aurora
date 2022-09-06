import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'grant_access.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            grantAccess(context),
            ColorPicker(
                wheelDiameter: 210,
                wheelWidth: 20,
                wheelHasBorder: true,
                color: context.read<HomeCubit>().selectedColor,
                title: const Center(child: Text("Keyboard Color Picker")),
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
                context.read<HomeCubit>().setColor(color);
            })

          ],
        ),
      ),
    );
  }
}