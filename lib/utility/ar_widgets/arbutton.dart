import 'package:aurora/user_interface/control_panel/state/keyboard_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArButton extends StatefulWidget {
  ArButton({
    super.key,
    required this.title,
    required this.action,
    this.isSelected = false,
    this.isEnabled = true,
    this.isLoading=false
  });

  String title;
  Function action;
  bool isSelected = false;
  bool isEnabled = true;
  bool isLoading=false;

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
    height = widget.isSelected ? 50 : 40;
    width = widget.isSelected ? 120 : 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
      child: widget.isLoading && widget.isSelected
          ? SizedBox(
              height: height,
              width: width,
              child: LinearProgressIndicator(
                color: context.read<KeyboardSettingsCubit>().selectedColor,
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
                        ? context.read<KeyboardSettingsCubit>().selectedColor
                        : Colors.grey[800]
                    : Colors.grey,
                duration: const Duration(milliseconds: 500),
                child: Center(
                    child: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: !widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.white,
                    shadows: <Shadow>[if (widget.isSelected) Shadow(offset: const Offset(1, 0), blurRadius: 1, color: context.read<KeyboardSettingsCubit>().invertedSelectedColor), if (widget.isSelected) Shadow(offset: const Offset(-1, 0), blurRadius: 1, color: context.read<KeyboardSettingsCubit>().invertedSelectedColor)],
                  ),
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
