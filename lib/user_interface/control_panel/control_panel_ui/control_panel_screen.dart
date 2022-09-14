import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/brightness_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/color_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/mode_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/speed_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../battery_manager/battery_manager_ui/battery_manager_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ControlPanelCubit>().initPanel();
  }

  @override
  Widget build(BuildContext context) {
   return Column(

     children: [
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Flexible(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const BatteryManagerScreen(),
                   brightnessController(context),
                   modeController(context: context,isVisible: context.watch<ControlPanelCubit>().isModeBarVisible),
                   speedController(context: context,isVisible: context.watch<ControlPanelCubit>().isSpeedBarVisible)
                 ],
               ),
             ),
             Flexible(child: colorController(context)),
           ],
         ),
       )
     ],
   );
  }
}