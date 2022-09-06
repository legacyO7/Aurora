import 'package:flutter/material.dart';

Widget button({
  required String title,
  required VoidCallback action
}){
  return InkWell(
    onTap: (){
      action();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Text(title),
    ),
  );
}