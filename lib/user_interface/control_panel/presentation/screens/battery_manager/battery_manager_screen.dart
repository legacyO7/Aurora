import 'package:another_xlider/another_xlider.dart';
import 'package:aurora/user_interface/control_panel/state/batter_manager_cubit.dart';
import 'package:aurora/user_interface/control_panel/state/batter_manager_state.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatteryManagerScreen extends StatefulWidget {
  const BatteryManagerScreen({Key? key}) : super(key: key);

  @override
  State<BatteryManagerScreen> createState() => _BatteryManagerScreenState();
}

class _BatteryManagerScreenState extends State<BatteryManagerScreen> {

  @override
  void initState() {
    super.initState();
    context.read<BatteryManagerCubit>().getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<BatteryManagerCubit,BatteryManagerInit>(
     builder: (BuildContext context, state) {
         return Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children:  [
           const Text("Battery Manager"),
           FlutterSlider(
             values: [state.batteryLevel.toDouble()],
             max: 100,
             min: Constants.kMinimumChargeLevel.toDouble(),
             handler: FlutterSliderHandler(
                 decoration: const BoxDecoration(),
                 child: Container(
                     width: 80,
                     height: 80,
                     decoration:  BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color:  context.watch<KeyboardSettingsBloc>().selectedColor,width: 5),
                         color: Colors.white),
                     child: Center(
                       child: Text(state.batteryLevel.toString(),
                         style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.black,),
                       ),
                     ))
             ),
             trackBar: FlutterSliderTrackBar(
               activeTrackBarHeight: 20,
               inactiveTrackBar: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: context.read<BatteryManagerCubit>().getSliderColor(context.read<KeyboardSettingsBloc>().selectedColor),
               ),
               activeTrackBar: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: context.read<BatteryManagerCubit>().getSliderColor(context.read<KeyboardSettingsBloc>().selectedColor)
               ),
             ),
             handlerAnimation: const FlutterSliderHandlerAnimation(
                 curve: Curves.bounceOut,
                 reverseCurve: Curves.bounceIn,
                 duration: Duration(milliseconds: 500),
                 scale: 1.5
             ),
             tooltip: FlutterSliderTooltip(
               disabled: true,
             ),
             onDragging:  (_, lowerValue, __) {
               context.read<BatteryManagerCubit>().setBatteryLevel(int.parse(lowerValue.toString().split('.')[0]));
             },
             onDragCompleted: (_, lowerValue, __) {
               context.read<BatteryManagerCubit>().finalizeBatteryLevel(int.parse(lowerValue.toString().split('.')[0]));
             },
           )
         ],
       );
     },
   );
  }
}