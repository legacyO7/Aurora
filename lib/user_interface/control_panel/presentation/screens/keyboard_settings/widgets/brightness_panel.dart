import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget brightnessController({required BuildContext context, required String title}) {
  List<ButtonAttribute<int>> brightnessList = [
    ButtonAttribute(title: "Off", value: 0),
    ButtonAttribute(title: "Low", value: 1),
    ButtonAttribute(title: "Medium", value: 2),
    ButtonAttribute(title: "High", value: 3),
  ];

  return SizedBox(
    height: 13.h,
    child: BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
      builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: Theme.of(context).textTheme.headlineSmall,),
              Row(
                  children: brightnessList
                      .map((e) => ArButton(
                          title: e.title,
                          isSelected: state.brightness == e.value,
                          action: () {
                            context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetBrightness(brightness: e.value ?? 0));
                          }))
                      .toList()),
            ],
          );
      },
    ),
  );
}
