import 'package:aurora/user_interface/keyboard_settings/keyboard_settings_state/keyboard_settings_cubit.dart';
import 'package:aurora/utility/button.dart';
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
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(title),
         Row(
            children: a.map((e) =>
                button(
                    title: e.title,
                    isSelected: context.watch<KeyboardSettingsCubit>().mode==e.value,
                    context: context,
                    action: () {
                      context.read<KeyboardSettingsCubit>().setMode(e.value??0);
            } )).toList()
          ),
       ],
     ),
   ),
 );


}
