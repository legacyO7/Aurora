import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:aurora/user_interface/battery_manager/battery_manager.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
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
    context.read<BatteryManagerBloc>().add(BatteryManagerEventInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<BatteryManagerBloc,BatteryManagerInit>(
     builder: (BuildContext context, state) {
         return Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children:  [
           Text("Charging threshold",style: Theme.of(context).textTheme.headlineSmall,),
           FlutterSlider(
             values: [state.batteryLevel.toDouble()],
             max: 100,
             min: Constants.kMinimumChargeLevel.toDouble(),
             handler: FlutterSliderHandler(
                 decoration: const BoxDecoration(),
                 child: Container(
                     decoration:  BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color:  context.selectedColor,width: 5),
                         color: ArColors.white),
                     child: Center(
                       child: Text(state.batteryLevel.toString(),
                         style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           color: ArColors.black,),
                       ),
                     ))
             ),
             trackBar: FlutterSliderTrackBar(
               activeTrackBarHeight: 20,
               inactiveTrackBar: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: context.read<BatteryManagerBloc>().getSliderColor(),
               ),
               activeTrackBar: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: context.read<BatteryManagerBloc>().getSliderColor()
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
             onDragging:  (_, lowerValue, __) =>
               context.read<BatteryManagerBloc>().add(BatteryManagerEventOnSlide(value:int.parse(lowerValue.toString().split('.')[0]))),
             onDragCompleted: (_, lowerValue, __) =>
               context.read<BatteryManagerBloc>().add(BatteryManagerEventOnSlideEnd(value: int.parse(lowerValue.toString().split('.')[0])))

           )
         ],
       );
     },
   );
  }
}