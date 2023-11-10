
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_state.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class ModeController extends StatelessWidget with GlobalMixin{

  ModeController({super.key,
    required this.title,
    this.isVisible=true
  });

  final bool isVisible;
  final String title;

  @override
  Widget build(BuildContext context) {

    return  AnimatedContainer(
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
                    children: Constants.modeTitle.map((e) =>
                        ArButton(
                            title: e,
                            isSelected: state.mode==Constants.modeTitle.indexOf(e),
                            action: () {
                              context.read<KeyboardSettingsBloc>().add(KeyboardSettingsEventSetMode(mode: Constants.modeTitle.indexOf(e)));
                            } )).toList()
                ),
              ],
            );
          },
        ),
      ),
    );
  }


}
