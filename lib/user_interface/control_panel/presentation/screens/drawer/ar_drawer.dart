import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/home/presentation/screens/widgets/privileged_run_button.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/theme_button.dart';

class ArDrawer extends StatelessWidget {
  const ArDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).canvasColor,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const GitButton(),
            const ThemeButton(aasText: true),
            const DisableButton(),
            const PrivilegedRunButton(),
            ArButton(
                animate: false,
                title: "Enforce Faustus", action: (){
                  ///TODO
            }),
            ArButton(
                animate: false,
                title: "${Constants.isLoggingEnabled?'Dis':'En'}able logging", action: (){
                    context.read<HomeBloc>().add(HomeEventEnableLogging());
                    Navigator.pop(context);
            }),

          ],
        ),
      ),
    );
  }
}
