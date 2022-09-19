import 'package:aurora/user_interface/battery_manager/presentation/screens/battery_manager_screen.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/screens/keyboard_settings_screen.dart';
import 'package:flutter/material.dart';

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
          children: const <Widget>[
            Expanded(
              child:BatteryManagerScreen()
            ),
            Expanded(
                flex: 2,
                child: KeyboardSettingsScreen())
          ],
        ),
      );
  }
}