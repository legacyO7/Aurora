import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ArButton extends StatefulWidget {
  const ArButton({super.key, required this.title, required this.action, this.isSelected = false, this.isEnabled = true, this.isLoading = false,this.edgeInsets});

  final String title;
  final Function action;
  final bool isSelected;
  final bool isEnabled;
  final bool isLoading;
  final EdgeInsetsGeometry? edgeInsets;

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
    height = widget.isSelected ? 4.5.h : 4.h;
    width = widget.isSelected ? 16.w : 15.w;
    return Container(
      margin: widget.edgeInsets,
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
                decoration: BoxDecoration(
                    border: Border.all(color: widget.isEnabled
                        ? widget.isSelected
                        ? context.selectedColor
                        : ArColors.greyDisabled!
                        : ArColors.grey,),
                    color: widget.isEnabled
                ? widget.isSelected
                ? context.selectedColorWithAlpha
                    : null
                : ArColors.grey,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                duration: const Duration(milliseconds: 500),
                child: Center(
                    child:
                     Text(
                       widget.title,
                       textAlign: TextAlign.center,
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
