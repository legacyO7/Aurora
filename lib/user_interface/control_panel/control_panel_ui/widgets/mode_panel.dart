import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget modeController({
  required BuildContext context,
  bool isVisible=true}) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Static",value: 0),
      ButtonAttribute(title: "Breating",value: 1),
      ButtonAttribute(title: "Color Cycle",value: 2),
      ButtonAttribute(title: "Strobing",value: 3)
  ];

 return AnimatedContainer(
   duration: const Duration(milliseconds: 300),
   height: isVisible?75:0,
   child: Row(
      children: a.map((e) =>
          button(
              title: e.title,
              isSelected: context.watch<ControlPanelCubit>().mode==e.value,
              context: context,
              action: () {
                context.read<ControlPanelCubit>().setMode(e.value??0);
      } )).toList()
    ),
 );


}
