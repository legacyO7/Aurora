import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget stateController({
     required String title,
     bool isVisible=true
   }){

   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Text(title),
       BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
         builder: (context, state){
           KeyboardSettingsBloc bloc= context.read<KeyboardSettingsBloc>();
          return Row(
             children: [

               ArRadioButton(
                 value: state.boot,
                 onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(boot: value)),
                 title: "Boot",
               ),

               ArRadioButton(
                 value: state.awake,
                 onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(awake: value)),
                 title: "Awake",
               ),

               ArRadioButton(
                 value: state.sleep,
                 onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(sleep: value)),
                 title: "Sleep",
               ),

           ]);
         }
        ),
     ],
   );

}