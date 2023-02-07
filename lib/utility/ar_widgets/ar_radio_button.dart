import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class ArRadioButton extends StatelessWidget{

  const ArRadioButton({super.key, required this.value, required this.onClick, required this.title});
  final bool value;
  final Function onClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: value?context.selectedColor:ArColors.transparent)),
      width: 143,
      child: Theme(
        data: Theme.of(context).copyWith(
            radioTheme: RadioThemeData(
                fillColor: MaterialStateColor.resolveWith((states) =>context.selectedColor))
        ),
        child: RadioMenuButton(
          value: value, groupValue: true, onChanged: (bool? value) => onClick(value),
          child: SizedBox(
              width: 80,
              child: Center(child: Text(title,
                textAlign: TextAlign.end,
                style: TextStyle(color:value?null: context.invertedColor,
                  fontWeight: value?FontWeight.w700:FontWeight.normal
      )))))));
  }

}