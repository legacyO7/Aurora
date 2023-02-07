import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_state.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_widgets.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UninstallButton extends StatelessWidget with GlobalMixin {
  const UninstallButton({super.key});

  Widget _selectorWindow() {
    return BlocListener<UninstallerBloc,Equatable>(
      listener: (BuildContext context, state) {
        if(state is UninstallProcessCompletedState) {
          _navigate(context);
        }
      },
      child: BlocBuilder<UninstallerBloc, Equatable>
        (builder: (BuildContext context, state) {

        if (state is UninstallInitState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ArCheckbox(
                  text: "Disable charging threshold",
                  isSelected: state.disableThreshold,
                  onChange: (_)=>context.read<UninstallerBloc>().add(UninstallEventCheckDisableServices(disableThreshold: !state.disableThreshold))
              ),

              if(!super.isMainLine())
              ArCheckbox(
                  text: "Disable faustus module",
                  isSelected: state.disableFaustusModule,
                  onChange: (_)=>context.read<UninstallerBloc>().add(UninstallEventCheckDisableServices(disableFaustusModule: !state.disableFaustusModule))
              ),
            ],
          );
        } else if (state is UninstallTerminalState) {
          return const TerminalScreen();
        }

        return placeholder();
      }),
    );
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
              onCancel: (){
                _navigate(context);
              });
        },
        icon: const Icon(Icons.delete_outline));
  }

  _navigate(BuildContext context)async{
    context.read<UninstallerBloc>().add(UninstallEventDispose());
    Navigator.pop(context);
    if(!await context.read<HomeBloc>().compatibilityChecker()) {
      context.read<HomeBloc>().add(HomeEventDispose());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SetupWizardScreen()));
    }
  }
}
