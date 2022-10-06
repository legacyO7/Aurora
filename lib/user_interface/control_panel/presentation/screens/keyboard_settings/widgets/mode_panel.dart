import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget modeController({
  required BuildContext context,
  required String title,
  bool isVisible=true}) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Static",value: 0),
      ButtonAttribute(title: "Breating",value: 1),
      ButtonAttribute(title: "Color Cycle",value: 2),
      ButtonAttribute(title: "Strobing",value: 3)
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
                           isSelected: state.mode==e.value,
                           action: () {
                             context.read<KeyboardSettingsBloc>().add(EventKSMode(mode: e.value??0));
                           } )).toList()
               ),
             ],
           );
       },
     ),
   ),
 );


}
