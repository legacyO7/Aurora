
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ModeController extends StatelessWidget with GlobalMixin{

  ModeController({super.key,
    required this.title,
    this.isVisible=true
  });

  final bool isVisible;
  final String title;

  final List<ButtonAttribute<int>> a=[
      ButtonAttribute(title: "Static",value: 0),
      ButtonAttribute(title: "Breathing",value: 1),
      ButtonAttribute(title: "Color Cycle",value: 2),
      ButtonAttribute(title: "Strobing",value: 3)
  ];

  @override
  Widget build(BuildContext context) {
    return  AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isVisible?100:0,
      child: SingleChildScrollView(
        child: BlocBuilder<KeyboardSettingsBloc,KeyboardSettingsState>(
          builder: (BuildContext context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Row(
                    children: a.map((e) =>
                        ArButton(
                            title: e.title,
                            isSelected: state.mode==e.value,
                            isEnabled: !(super.isMainLine() && e.value==3),
                            action: () {
                              context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetMode(mode: e.value??0));
                            } )).toList()
                ),
              ],
            );
          },
        ),
      ),
    );
  }


}
