import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget button({
  required String title,
  required VoidCallback action,
  bool isSelected=false,
  required BuildContext context
}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 1),
    child: InkWell(
      onTap: (){
        action();
      },
      child: AnimatedContainer(
        height: isSelected?50:40,
        width: isSelected?120:100,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        color: isSelected?context.read<ControlPanelCubit>().selectedColor:Colors.grey[800],
        duration: const Duration(milliseconds: 500),
        child: Center(child: Text(title,style: TextStyle(fontWeight: !isSelected?FontWeight.bold:FontWeight.normal,
        color: isSelected?context.read<ControlPanelCubit>().invertedSelectedColor:Colors.white
        ),)),
      ),
    ),
  );
}

class ButtonAttribute<T>{
  String title;
  T? value;

  ButtonAttribute({required this.title, this.value});
}