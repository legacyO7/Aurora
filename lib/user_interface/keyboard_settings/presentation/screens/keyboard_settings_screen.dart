
import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_state.dart';
import 'package:aurora/utility/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/brightness_panel.dart';
import 'widgets/color_panel.dart';
import 'widgets/mode_panel.dart';
import 'widgets/speed_panel.dart';


class KeyboardSettingsScreen extends StatefulWidget {
  const KeyboardSettingsScreen({Key? key}) : super(key: key);

  @override
  State<KeyboardSettingsScreen> createState() => _KeyboardSettingsScreenState();
}

class _KeyboardSettingsScreenState extends State<KeyboardSettingsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<KeyboardSettingsCubit>().initPanel();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       BlocBuilder<KeyboardSettingsCubit, KeyboardSettingsState>(
         builder: (BuildContext context, state) {
     if (state is KeyboardSettingsLoadedState) {
       return Row(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Flexible(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     brightnessController(title: "Brightness", context: context),
                     modeController(title: "Mode", context: context,isVisible: context.watch<KeyboardSettingsCubit>().isModeBarVisible),
                     speedController(title: "Speed", context: context,isVisible: context.watch<KeyboardSettingsCubit>().isSpeedBarVisible)
                   ],
                 )
               ),
               Flexible(child: colorController(context)),
             ],
           );
     }else{
       return placeholder();
     }
         }
       )
     ],
   );
  }
}