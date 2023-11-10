
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


Widget speedController({
  required BuildContext context,
  required String title,
  bool isVisible=true}) {

 return AnimatedContainer(
   duration: const Duration(milliseconds: 300),
   height: isVisible?13.h:0,
   child: SingleChildScrollView(
     child: BlocBuilder<KeyboardSettingsBloc,KeyboardSettingsState>(
       builder: (BuildContext context, state) {
           return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(title,style: Theme.of(context).textTheme.headlineSmall,),
             Row(
                 children: Constants.speedTitle.map((e) =>
                     ArButton(
                         title: e,
                         isSelected: state.speed==Constants.speedTitle.indexOf(e),
                         action: () {
                           context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetSpeed(speed: Constants.speedTitle.indexOf(e)));
                         } )).toList()
             ),
           ],
         );
       }
     ),
   ),
 );


}
