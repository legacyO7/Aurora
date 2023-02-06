import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flutter/material.dart';

class ArRadioButton extends StatelessWidget{

  const ArRadioButton({super.key, required this.value, required this.onClick, required this.title});
  final bool value;
  final Function onClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 143,
      child: Theme(
        data: Theme.of(context).copyWith(
            radioTheme: RadioThemeData(
                fillColor: MaterialStateColor.resolveWith((states) => context.invertedColor))
        ),
        child: RadioMenuButton(
          style: ButtonStyle(backgroundColor: value?MaterialStatePropertyAll(context.selectedColor):null,),
          value: value, groupValue: true, onChanged: (bool? value) => onClick(value),
          child:  Text(title),),
      ),
    );
  }

}