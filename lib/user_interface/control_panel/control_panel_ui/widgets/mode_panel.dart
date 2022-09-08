import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget modeController(BuildContext context) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Static",value: 0),
      ButtonAttribute(title: "Breating",value: 1),
      ButtonAttribute(title: "Color Cycle",value: 2),
      ButtonAttribute(title: "Strobing",value: 3)
  ];

 return Row(
    children: a.map((e) =>
        button(
            title: e.title,
            isSelected: context.watch<ControlPanelCubit>().mode==e.value,
            context: context,
            action: () {
      context.read<HomeCubit>().setMode(e.value).then((value) {
        if(value) {
          context.read<ControlPanelCubit>().setMode(e.value);
        }
      });
    } )).toList()
  );


}
