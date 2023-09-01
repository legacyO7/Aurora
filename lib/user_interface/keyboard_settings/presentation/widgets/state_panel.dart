import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateController extends StatelessWidget {

  const StateController({
    super.key,
    required this.title,
    this.isVisible=true
    });

  final String title;
  final bool isVisible;



  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.headlineSmall,),
          BlocBuilder<KeyboardSettingsBloc, KeyboardSettingsState>(
              builder: (context, state){
                KeyboardSettingsBloc bloc= context.read<KeyboardSettingsBloc>();

                bool getState(String e,{bool addEvent=false}){
                   switch(Constants.stateTitle.indexOf(e)){
                     case 0:
                       if(addEvent){
                         bloc.add(KeyboardSettingsEventSetState(awake: state.awake));
                       }
                       return state.awake;
                     case 1:
                       if(addEvent){
                         bloc.add(KeyboardSettingsEventSetState(sleep: state.sleep));
                       }
                       return state.sleep;
                     case 2:
                       if(addEvent){
                         bloc.add(KeyboardSettingsEventSetState(boot: state.boot));
                       }
                       return state.boot;
                     default: return false;
                   }
                }


               return  Row(children: Constants.stateTitle.map((e) => ArButton(
                    title: e,
                    isSelected: getState(e),
                    action: (){
                      getState(e,addEvent: true);
                    }),).toList(),);

              }
          ),
        ],
      ),
    );
  }
}


