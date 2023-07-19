import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/clear_cache_widget.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/enforce_widget.dart';
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/logger_button.dart';
import 'package:aurora/user_interface/home/presentation/screens/widgets/privileged_run_button.dart';
import 'package:flutter/material.dart';

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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GitButton(),
            ThemeButton(aasText: true),
            DisableButton(),
            PrivilegedRunButton(),
            EnforceWidget(),
            LoggerButton(),
            ClearCacheWidget()
          ],
        ),
      ),
    );
  }
}
