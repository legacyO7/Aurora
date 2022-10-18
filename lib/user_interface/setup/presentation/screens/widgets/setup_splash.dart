import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

Widget setupSplash(){

  return Center(
    child: AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          'Aurora',
          textStyle: const TextStyle(
            fontSize: 50.0,
          ),
          colors: [
            ArColors.red,
            ArColors.pink,
            ArColors.orange,
            ArColors.yellow,
            ArColors.green,
            ArColors.deepPurple,
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

