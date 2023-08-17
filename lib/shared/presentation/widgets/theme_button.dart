import 'package:aurora/user_interface/theme/theme.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeButton extends StatefulWidget{
  const ThemeButton({super.key,this.asText=false});
  final bool asText;

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
            return widget.asText?
            ArButton(
                title: "Theme: $tooltipText",
                action: ()=>context.read<ThemeBloc>().add(ThemeEventSwitch()),
                animate: false,
            ):
            IconButton(
                  onPressed: () {
                    context.read<ThemeBloc>().add(ThemeEventSwitch());
                    },
                  tooltip:  tooltipText,
                  icon: icon

      );
          }
    );
  }
}
