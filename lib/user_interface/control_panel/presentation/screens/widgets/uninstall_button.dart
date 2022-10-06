import 'package:aurora/user_interface/control_panel/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_state.dart';
import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/setup_wizard_screen.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/ar_widgets/ardialog.dart';
import 'package:aurora/utility/placeholder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UninstallButton extends StatelessWidget {
  const UninstallButton({super.key});

  Widget _selectorWindow() {
    return BlocBuilder<UninstallerBloc, Equatable>(builder: (BuildContext context, state) {
      if (state is ControlPanelStateInit) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              title: const Text("Disable charging threshold"),
              value: state.disableThreshold,
              onChanged: (_) {
                context.read<UninstallerBloc>().add(EventUInCheckDisableServices(disableThreshold: !state.disableThreshold));
              },
            ),
            CheckboxListTile(
              title: const Text("Disable faustus module"),
              value: state.disableFaustusModule,
              onChanged: (_) {
                context.read<UninstallerBloc>().add(EventUInCheckDisableServices(disableFaustusModule: !state.disableFaustusModule));
              },
            )
          ],
        );
      } else if (state is ControlPanelTerminalState) {
        return const TerminalScreen();
      }

      return placeholder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await arDialog(
              context: context,
              title: "Disable Services",
              subject: "Select the services to be disabled",
              optionalWidget: _selectorWindow(),
              onConfirm: () {
                context.read<UninstallerBloc>().add(EventUInSubmitDisableServices());
              },
              onCancel: () {
                Navigator.pop(context);
                context.read<HomeCubit>().dispose();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupWizardScreen()));
              });
        },
        icon: const Icon(Icons.delete_outline));
  }
}
