import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_state.dart';
import 'package:aurora/utility/button.dart';
import 'package:aurora/utility/placeholder.dart';
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
    child: BlocBuilder<KeyboardSettingsCubit, KeyboardSettingsState>(
      builder: (BuildContext context, state) {
        if (state is KeyboardSettingsLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Row(
                  children: a
                      .map((e) => button(
                          title: e.title,
                          isSelected: state.brightness == e.value,
                          context: context,
                          action: () {
                            context.read<KeyboardSettingsCubit>().setBrightness(e.value ?? 0);
                          }))
                      .toList()),
            ],
          );
        } else {
          return placeholder();
        }
      },
    ),
  );
}
