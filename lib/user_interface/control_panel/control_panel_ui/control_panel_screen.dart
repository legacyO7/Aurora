import 'package:aurora/user_interface/battery_manager/battery_manager_ui/battery_manager_screen.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/keyboard_settings/keyboard_settings_ui/keyboard_settings_screen.dart';
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
    context.read<HomeCubit>().requestAccess();
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