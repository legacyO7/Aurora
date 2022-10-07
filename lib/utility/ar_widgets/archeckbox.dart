import 'package:flutter/material.dart';

class ArCheckbox extends StatelessWidget{

   const ArCheckbox({
    required this.text,
    required this.isSelected,
    required this.onChange,
    super.key,
  });

  final String text;
  final bool isSelected;
  final Function onChange;

   MaterialStateProperty<Color> getMaterialColor(Color color)=>
      MaterialStateProperty.all<Color>(color);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            fillColor: getMaterialColor(isSelected?Colors.red:Colors.transparent),
            checkColor:  getMaterialColor(Colors.white),
            overlayColor:  getMaterialColor(Colors.orange),
            side: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          )
      ),
      child: CheckboxListTile(
        title: const Text("Disable faustus module"),
        value: isSelected,
        onChanged: (value)=> onChange(value),
      ),
    );
  }

}