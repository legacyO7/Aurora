import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/brightness_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/color_panel.dart';
import 'package:flutter/material.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ControlPanelScreen> {
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       ColorPanel(),
       brightnessController(context)
     ],
   );
  }
}