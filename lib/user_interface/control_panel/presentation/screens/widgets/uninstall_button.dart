import 'package:aurora/user_interface/control_panel/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_state.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_wizard_screen.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
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

            ArCheckbox(
                text: "Disable charging threshold",
                isSelected: state.disableThreshold,
                onChange: (_)=>context.read<UninstallerBloc>().add(UninstallEventCheckDisableServices(disableThreshold: !state.disableThreshold))
            ),

            ArCheckbox(
                text: "Disable faustus module",
                isSelected: state.disableFaustusModule,
                onChange: (_)=>context.read<UninstallerBloc>().add(UninstallEventCheckDisableServices(disableFaustusModule: !state.disableFaustusModule))
            ),
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
                context.read<UninstallerBloc>().add(UninstallEventSubmitDisableServices());
              },
              onCancel: () async {
                Navigator.pop(context);
                if(!await context.read<HomeBloc>().compatibilityChecker()) {
                  context.read<HomeBloc>().add(HomeEventDispose());
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupWizardScreen()));
                }
              });
        },
        icon: const Icon(Icons.delete_outline));
  }
}
