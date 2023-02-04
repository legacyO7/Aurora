import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';


class ArWindowButtons extends StatelessWidget {
  const ArWindowButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      mouseOver: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.grey.shade600
          : Colors.grey.shade300,
      mouseDown: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade400,
      iconMouseOver: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      iconMouseDown: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      normal: Theme
          .of(context)
          .colorScheme
          .surface,
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: const Color(0xFFD32F2F),
      mouseDown: const Color(0xFFB71C1C),
      iconNormal: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      iconMouseOver: Colors.white,
      normal: Theme
          .of(context)
          .colorScheme
          .surface,
    );

    return Row(
      children: [
        CloseWindowButton(colors: closeButtonColors, animate: true),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(8),
          ),
          child:
          MinimizeWindowButton(colors: buttonColors, animate: true),
        ),
      ],
    );
  }
}
