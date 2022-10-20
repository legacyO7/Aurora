import 'package:aurora/utility/ar_widgets/colors.dart';
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
            fillColor: getMaterialColor(isSelected?ArColors.red:ArColors.transparent),
            checkColor:  getMaterialColor(ArColors.white),
            overlayColor:  getMaterialColor(ArColors.orange),
            side: const BorderSide(
              color: ArColors.red,
              width: 1,
            ),
          )
      ),
      child: CheckboxListTile(
        title: Text(text),
        value: isSelected,
        onChanged: (value)=> onChange(value),
      ),
    );
  }

}