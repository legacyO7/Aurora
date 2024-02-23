import 'package:aurora/user_interface/preferences/presentation/screens/preferences.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';

class EditPreferencesButton extends StatelessWidget with GlobalMixin {
  const EditPreferencesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ArButton(
      action: () async {
        showPreferencesDialog();
      },
      title: "Edit Preferences",
      animate: false,
    );
  }
}
