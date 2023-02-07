import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/theme_button.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanelScreen> with GlobalMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: context.read<KeyboardSettingsBloc>().selectedColor),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                    child: const ThemeButton()),
                Container(
                    decoration: BoxDecoration(
                        border: Border.symmetric(vertical: BorderSide.none,horizontal: BorderSide(color:context.selectedColor ))
                    ),
                    child: const GitButton()),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: context.selectedColor),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: const UninstallButton())
              ],
            ),
            if(super.systemHasSystemd())
            const Expanded(
              child:BatteryManagerScreen()
            ),
            if(Constants.globalConfig.arMode!=ARMODE.batterymanager)
             Expanded(
                flex: super.isMainLine()?3:2,
                child: const KeyboardSettingsScreen())
          ],
        ),
      );
  }
}