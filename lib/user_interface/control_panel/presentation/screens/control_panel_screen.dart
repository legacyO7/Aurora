
import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/theme_button.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanelScreen> {

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
                        border: Border.symmetric(vertical: BorderSide.none,horizontal: BorderSide(color:context.watch<KeyboardSettingsBloc>().selectedColor ))
                    ),
                    child: const GitButton()),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: context.watch<KeyboardSettingsBloc>().selectedColor),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: const UninstallButton())
              ],
            ),
            if(Constants.globalConfig.arMode!=ARMODE.faustus)
            const Expanded(
              child:BatteryManagerScreen()
            ),
            if(Constants.globalConfig.arMode!=ARMODE.batterymanager)
            const Expanded(
                flex: 2,
                child: KeyboardSettingsScreen())
          ],
        ),
      );
  }
}