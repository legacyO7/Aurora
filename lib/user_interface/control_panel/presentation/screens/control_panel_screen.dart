
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/git_button.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/uninstall_button.dart';
import 'package:flutter/material.dart';

import 'battery_manager/battery_manager_screen.dart';
import 'keyboard_settings/keyboard_settings_screen.dart';

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
              children:const [
                GitButton(),
                UninstallButton()
              ],
            ),
            const Expanded(
              child:BatteryManagerScreen()
            ),
            const Expanded(
                flex: 2,
                child: KeyboardSettingsScreen())
          ],
        ),
      );
  }
}