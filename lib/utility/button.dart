import 'package:flutter/material.dart';

Widget button({
  required String title,
  required VoidCallback action,
  bool isSelected=false
}){
  return InkWell(
    onTap: (){
      action();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      color: isSelected?Colors.blue:Colors.transparent,
      child: Text(title),
    ),
  );
}

class ButtonAttribute<T>{
  String title;
  T? value;

  ButtonAttribute({required this.title, this.value});
}