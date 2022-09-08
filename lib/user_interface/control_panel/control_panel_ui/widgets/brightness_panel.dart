import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget brightnessController(BuildContext context) {

  List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Off",value: 0),
      ButtonAttribute(title: "Low",value: 1),
      ButtonAttribute(title: "Medium",value: 2),
      ButtonAttribute(title: "High",value: 3),
  ];

 return Row(
    children: a.map((e) =>
        button(
            title: e.title,
            isSelected: context.watch<ControlPanelCubit>().brightness==e.value,
            context: context,
            action: () {
      context.read<HomeCubit>().setBrightness(e.value).then((value) {
        if(value) {
          context.read<ControlPanelCubit>().setBrightness(e.value);
        }
      });
    } )).toList()
  );


}
