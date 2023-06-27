import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
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
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      ArButton(title: "Boot",
                          isSelected: state.boot,
                          action: (){
                            bloc.add(KeyboardSettingsEventSetState(boot: state.boot));
                          }),

                      ArButton(title: "Awake",
                          isSelected: state.awake,
                          action: (){
                            bloc.add(KeyboardSettingsEventSetState(awake: state.awake));
                          }),

                      ArButton(title:  "Sleep",
                          isSelected: state.sleep,
                          action: (){
                            bloc.add(KeyboardSettingsEventSetState(sleep: state.sleep));
                          }),

                    ]);
              }
          ),
        ],
      ),
    );
  }
}


