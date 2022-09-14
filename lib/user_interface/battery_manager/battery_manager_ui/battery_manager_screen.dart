import 'package:another_xlider/another_xlider.dart';
import 'package:aurora/user_interface/battery_manager/battery_manager_state/batter_manager_cubit.dart';
import 'package:aurora/user_interface/battery_manager/battery_manager_state/batter_manager_state.dart';
import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
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
   return BlocBuilder<BatteryManagerCubit,BatteryManagerState>(
     builder: (BuildContext context, state) {
       if(state is BatteryManagerInit) {
         return Column(

         children:  [

           FlutterSlider(
             values: [state.batteryLevel.toDouble()],
             max: 100,
             min: Constants.kMinimumChargeLevel.toDouble(),
             tooltip: FlutterSliderTooltip(
                 textStyle: const TextStyle(fontSize: 17, color: Colors.white),
                 boxStyle: FlutterSliderTooltipBox(
                     decoration: BoxDecoration(
                         color: Colors.redAccent.withOpacity(0.7)
                     )
                 )
             ),
             handler: FlutterSliderHandler(
                 decoration: const BoxDecoration(),
                 child: Container(
                     width: 60,
                     height: 60,
                     decoration:  BoxDecoration(
                         shape: BoxShape.circle,
                         color: context.watch<ControlPanelCubit>().selectedColor),
                     child: Center(
                       child: Text(state.batteryLevel.toString(),
                         style: TextStyle(color: context.watch<ControlPanelCubit>().invertedSelectedColor),),
                     ))
             ),
             rightHandler: FlutterSliderHandler(
               child: const Icon(Icons.chevron_left, color: Colors.red, size: 24,),
             ),
             trackBar: FlutterSliderTrackBar(
               activeTrackBarHeight: 20,
               inactiveTrackBar: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.black12,
                 border: Border.all(width: 3, color: Colors.green),
               ),
               activeTrackBar: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: Colors.lightGreen.withOpacity(0.5)
               ),
             ),
             onDragging:  (handlerIndex, lowerValue, upperValue) {
               context.read<BatteryManagerCubit>().setBatteryLevel(int.parse(lowerValue.toString().split('.')[0]));
             },
             onDragCompleted: (handlerIndex, lowerValue, upperValue) {
               context.read<BatteryManagerCubit>().finalizeBatteryLevel(int.parse(lowerValue.toString().split('.')[0]));
             },
           )
         ],
       );
       }else {
         return Container();
       }
     },
   );
  }
}