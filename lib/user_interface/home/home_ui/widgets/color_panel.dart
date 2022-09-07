import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorPanel extends StatefulWidget {
  const ColorPanel({Key? key}) : super(key: key);

  @override
  State<ColorPanel> createState() => _ColorPanelState();
}

class _ColorPanelState extends State<ColorPanel> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
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