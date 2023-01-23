import 'package:aurora/user_interface/control_panel/state/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/theme_event.dart';
import 'package:aurora/user_interface/control_panel/state/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeButton extends StatefulWidget{
  const ThemeButton({super.key});

  @override
  State<StatefulWidget> createState() {
   return _ThemeButtonState();
  }

}

class _ThemeButtonState extends State<ThemeButton>{

  @override
  void initState() {
    super.initState();
    context.read<ThemeBloc>().add(ThemeEventInit());
  }

  setIcon(ThemeMode arTheme){
    switch(arTheme) {
      case ThemeMode.system:
        icon=const Icon(Icons.light);
        tooltipText="System Theme";
        break;
      case ThemeMode.light:
        icon=const Icon(Icons.light_mode_outlined);
        tooltipText="Light Theme";
        break;
      case ThemeMode.dark:
        icon=const Icon(Icons.dark_mode_outlined);
        tooltipText="Dark Theme";
        break;
    }
  }

  String tooltipText='';
  Icon icon=const Icon(Icons.timer_sharp);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
          builder:(context, state){
            setIcon(state.arTheme);
            return IconButton(
                  onPressed: () {
                    context.read<ThemeBloc>().add(ThemeEventSwitch());
                    },
                  tooltip: tooltipText,
                  icon: icon

      );
          }
    );
  }
}
