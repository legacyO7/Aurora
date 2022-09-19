import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:aurora/utility/button.dart';
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
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(title),
         Row(
            children: a.map((e) =>
                button(
                    title: e.title,
                    isSelected: context.watch<KeyboardSettingsCubit>().speed==e.value,
                    context: context,
                    action: () {
                      context.read<KeyboardSettingsCubit>().setSpeed(e.value??0);
                    } )).toList()
          ),
       ],
     ),
   ),
 );


}
