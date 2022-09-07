import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget speedController(BuildContext context) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Slow",value: 0),
      ButtonAttribute(title: "Medium",value: 1),
      ButtonAttribute(title: "Fast",value: 2),
  ];

 return Row(
    children: a.map((e) =>
        button(
            title: e.title,
            isSelected: context.watch<ControlPanelCubit>().speed==e.value,
            action: () {
      context.read<HomeCubit>().setSpeed(e.value).then((value) {
        if(value) {
          context.read<ControlPanelCubit>().setSpeed(e.value);
        }
      });
    } )).toList()
  );


}
