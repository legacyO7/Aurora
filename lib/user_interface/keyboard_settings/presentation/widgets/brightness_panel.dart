import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget brightnessController({required BuildContext context, required String title}) {

  return SizedBox(
    height: 13.h,
    child: BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
      builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: Theme.of(context).textTheme.headlineSmall,),
              Row(
                  children: Constants.brightnessTitle
                      .map((e) => ArButton(
                          title: e,
                          isSelected: state.brightness == Constants.brightnessTitle.indexOf(e),
                          action: () {
                            context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetBrightness(brightness: Constants.brightnessTitle.indexOf(e)));
                          }))
                      .toList()),
            ],
          );
      },
    ),
  );
}
