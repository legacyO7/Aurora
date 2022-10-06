import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget brightnessController({required BuildContext context, required String title}) {
  List<ButtonAttribute<int>> a = [
    ButtonAttribute(title: "Off", value: 0),
    ButtonAttribute(title: "Low", value: 1),
    ButtonAttribute(title: "Medium", value: 2),
    ButtonAttribute(title: "High", value: 3),
  ];

  return SizedBox(
    height: 100,
    child: BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
      builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Row(
                  children: a
                      .map((e) => ArButton(
                          title: e.title,
                          isSelected: state.brightness == e.value,
                          action: () {
                            context.read<KeyboardSettingsBloc>().add(EventKSBrightness(brightness: e.value ?? 0));
                          }))
                      .toList()),
            ],
          );
      },
    ),
  );
}
