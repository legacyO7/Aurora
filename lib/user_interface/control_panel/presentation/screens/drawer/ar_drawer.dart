import 'package:aurora/shared/presentation/shared_presentation.dart';
import 'package:aurora/shared/presentation/widgets/edit_preference_button.dart';
import 'package:aurora/user_interface/home/presentation/screens/widgets/privileged_run_button.dart';
import 'package:flutter/material.dart';


class ArDrawer extends StatelessWidget {
  const ArDrawer({super.key});

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
        child:  const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GitButton(),
            ThemeButton(asText: true),
            DisableButton(),
            PrivilegedRunButton(),
            EnforceWidget(),
            LoggerButton(),
            ClearCacheWidget(),
            EditPreferencesButton()
          ],
        ),
      ),
    );
  }
}
