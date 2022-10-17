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
            Colors.red,
            Colors.pink,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.deepPurple,
            Colors.blue,
            Colors.cyan,
          ],
        ),
      ],
      isRepeatingAnimation: true,
      repeatForever: true,
    ),
  );
}

