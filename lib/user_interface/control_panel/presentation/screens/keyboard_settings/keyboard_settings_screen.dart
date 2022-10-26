import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class KeyboardSettingsScreen extends StatefulWidget {
  const KeyboardSettingsScreen({Key? key}) : super(key: key);

  @override
  State<KeyboardSettingsScreen> createState() => _KeyboardSettingsScreenState();
}

class _KeyboardSettingsScreenState extends State<KeyboardSettingsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventInit());
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
         builder: (BuildContext context, state) {
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
                     modeController(title: "Mode", context: context,isVisible: context.watch<KeyboardSettingsBloc>().isModeBarVisible),
                     speedController(title: "Speed", context: context,isVisible: context.watch<KeyboardSettingsBloc>().isSpeedBarVisible)
                   ],
                 )
               ),
               Flexible(child: colorController(context)),
             ],
           );
         }
       )
     ],
   );
  }
}