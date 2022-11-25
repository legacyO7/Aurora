
import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
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
          children:  <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:const [
                GitButton(),
                UninstallButton()
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