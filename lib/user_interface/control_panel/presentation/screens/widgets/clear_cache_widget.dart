import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_alert.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCacheWidget extends StatelessWidget {
  const ClearCacheWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ArButton(
      title: "Clear Cache",
      animate: false,
      action: () {
        arAlert(
            content: "Settings will be restored back to default",
            actions: [
              ArButton(
                  title: "Yes",
                  action: () => context.read<TerminalBloc>().clearCache()
              )
            ]);
      });
  }

}