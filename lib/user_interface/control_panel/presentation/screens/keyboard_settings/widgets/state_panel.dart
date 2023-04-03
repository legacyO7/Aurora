import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_radio_button.dart';
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

                      ArRadioButton(
                        value: state.boot,
                        onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(boot: value)),
                        title: "Boot",
                      ),

                      ArRadioButton(
                        value: state.awake,
                        onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(awake: value)),
                        title: "Awake",
                      ),

                      ArRadioButton(
                        value: state.sleep,
                        onClick: (bool value)=> bloc.add(KeyboardSettingsEventSetState(sleep: value)),
                        title: "Sleep",
                      ),

                    ]);
              }
          ),
        ],
      ),
    );
  }
}


