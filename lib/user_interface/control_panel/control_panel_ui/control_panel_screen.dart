import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/brightness_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/color_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/mode_panel.dart';
import 'package:aurora/user_interface/control_panel/control_panel_ui/widgets/speed_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Row(
           children: [
             Flexible(
               child: SizedBox(
                 height: MediaQuery.of(context).size.height/2,
                 child: Column(
                   children: [
                     brightnessController(context),
                     modeController(context),
                     speedController(context: context,isVisible: context.watch<ControlPanelCubit>().isSpeedBarVisible)
                   ],
                 ),
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