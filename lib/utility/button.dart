import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget button({
  required String title,
  required VoidCallback action,
  bool isSelected=false,
  bool isLoading=false,
  bool isEnabled=true,
  required BuildContext context
}){
  double height= isSelected?50:40;
  double width= isSelected?120:100;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 1),
    child:
    isLoading && isSelected?
    SizedBox(
        height: height,
        width: width,
        child: LinearProgressIndicator(
          color: context.read<KeyboardSettingsCubit>().selectedColor,
        )):
    InkWell(
      onTap: (){
        if(isEnabled) {
          action();
        }
      },
      child: AnimatedContainer(
        height: isSelected?50:40,
        width: isSelected?120:100,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        color: isEnabled? isSelected?context.read<KeyboardSettingsCubit>().selectedColor:Colors.grey[800]:Colors.grey,
        duration: const Duration(milliseconds: 500),
        child: Center(child: Text(title,style: TextStyle(fontWeight: !isSelected?FontWeight.bold:FontWeight.normal,
        color: Colors.white,
          shadows:  <Shadow>[
            if(isSelected)
            Shadow(
              offset: const Offset(1, 0),
              blurRadius: 1,
              color: context.read<KeyboardSettingsCubit>().invertedSelectedColor
            ),
            if(isSelected)
              Shadow(
                offset: const Offset(-1, 0),
                blurRadius: 1,
                color: context.read<KeyboardSettingsCubit>().invertedSelectedColor
            )
          ],
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