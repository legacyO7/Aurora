
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget speedController({
  required BuildContext context,
  required String title,
  bool isVisible=true}) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Slow",value: 0),
      ButtonAttribute(title: "Medium",value: 1),
      ButtonAttribute(title: "Fast",value: 2),
  ];

 return AnimatedContainer(
   duration: const Duration(milliseconds: 300),
   height: isVisible?100:0,
   child: SingleChildScrollView(
     child: BlocBuilder<KeyboardSettingsBloc,KeyboardSettingsState>(
       builder: (BuildContext context, state) {
           return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(title),
             Row(
                 children: a.map((e) =>
                     ArButton(
                         title: e.title,
                         isSelected: state.speed==e.value,
                         action: () {
                           context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetSpeed(speed: e.value??0));
                         } )).toList()
             ),
           ],
         );
       }
     ),
   ),
 );


}
