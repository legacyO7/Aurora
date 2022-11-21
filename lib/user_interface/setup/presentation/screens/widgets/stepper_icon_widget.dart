import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:flutter/material.dart';

Widget stepperIcon({required int stepValue, required int index}){
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(width: 3, color: ArColors.purple),
      shape: BoxShape.circle,
    ),
    child: stepValue==index?
     const Icon(
      Icons.done_outline_rounded,
      color:ArColors.purpleLight,
    ):
    stepValue>index?
    const Icon(
      Icons.done,
      color: ArColors.green,
    ):
    const Icon(
      Icons.flag
    ),
  );
}