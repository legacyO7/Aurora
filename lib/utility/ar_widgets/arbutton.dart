import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArButton extends StatefulWidget {
  const ArButton({super.key, required this.title, required this.action, this.isSelected = false, this.isEnabled = true, this.isLoading = false});

  final String title;
  final Function action;
  final bool isSelected;
  final bool isEnabled;
  final bool isLoading;

  @override
  State<ArButton> createState() {
    return _ArButtonState();
  }
}

class _ArButtonState extends State<ArButton> {
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = widget.isSelected ? 50 : 40;
    width = widget.isSelected ? 120 : 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
      child: widget.isLoading && widget.isSelected
          ? SizedBox(
              height: height,
              width: width,
              child: LinearProgressIndicator(
                color: context.read<KeyboardSettingsBloc>().selectedColor,
              ))
          : InkWell(
              onTap: () async {
                if (widget.isEnabled) {
                  await widget.action();
                }
              },
              child: AnimatedContainer(
                height: height,
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: widget.isEnabled
                    ? widget.isSelected
                        ? context.read<KeyboardSettingsBloc>().selectedColor
                        : ArColors.greyDisabled
                    : ArColors.grey,
                duration: const Duration(milliseconds: 500),
                child: Center(
                    child: Stack(
                      children: <Widget>[
                       if(widget.isSelected)
                        Text(
                          widget.title,
                          style: TextStyle(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = ArColors.purpleDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: ArColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

class ButtonAttribute<T> {
  String title;
  T? value;

  ButtonAttribute({required this.title, this.value});
}
