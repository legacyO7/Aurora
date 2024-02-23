import 'package:aurora/user_interface/keyboard_settings/keyboard_settings.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class KeyboardSettingsScreen extends StatefulWidget {
  const KeyboardSettingsScreen({super.key});

  @override
  State<KeyboardSettingsScreen> createState() => _KeyboardSettingsScreenState();
}

class _KeyboardSettingsScreenState extends State<KeyboardSettingsScreen> with GlobalMixin {

  @override
  void initState() {
    super.initState();
    context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventInit());
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
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
                     ModeController(title: "Mode", isVisible: context.watch<KeyboardSettingsBloc>().isModeBarVisible),
                     speedController(title: "Speed", context: context,isVisible: context.watch<KeyboardSettingsBloc>().isSpeedBarVisible),
                     StateController(title: "State",isVisible: super.isMainLine())
                   ],
                 )
               ),
               Flexible(
                   child: colorController(context)),
             ],
           );
         }
       )
     ],
   );
  }
}