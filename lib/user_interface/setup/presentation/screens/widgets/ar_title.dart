import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:flutter/material.dart';

Widget arTitle(){

  return Center(
    child: AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          'Aurora',
          textStyle: const TextStyle(
            fontSize: 50,
          ),
          colors: [
            ArColors.red,
            ArColors.pink,
            ArColors.orange,
            ArColors.yellow,
            ArColors.green,
            ArColors.purpleDark,
            ArColors.blue,
            ArColors.cyan,
          ],
        ),
      ],
      isRepeatingAnimation: true,
      repeatForever: true,
    ),
  );
}

