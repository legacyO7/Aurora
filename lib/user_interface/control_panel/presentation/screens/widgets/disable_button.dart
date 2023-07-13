import 'package:aurora/user_interface/control_panel/presentation/state/disable_services/disable_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_widgets.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class DisableButton extends StatelessWidget with GlobalMixin {
  const DisableButton({super.key});

  Widget _selectorWindow() {
    return BlocListener<DisablerBloc,DisableState>(
      listener: (BuildContext context, state) {
        if(state.state == DisableStateStates.completed) {
          _navigate(context);
        }
      },
      child: BlocBuilder<DisablerBloc, DisableState>
        (builder: (BuildContext context, state) {

        if (state.state == DisableStateStates.init) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ArCheckbox(
                  text: "Disable charging threshold",
                  isSelected: state.disableThreshold,
                  onChange: (_)=>context.read<DisablerBloc>().add(DisableEventCheckDisableServices(disableThreshold: !state.disableThreshold))
              ),

              if(!super.isMainLine()&&!super.isFallbackedWorkingDirectory())
              ArCheckbox(
                  text: "Disable faustus module",
                  isSelected: state.disableFaustusModule,
                  onChange: (_)=>context.read<DisablerBloc>().add(DisableEventCheckDisableServices(disableFaustusModule: !state.disableFaustusModule))
              ),
              if(super.isInstalledPackage()&&!super.isFallbackedWorkingDirectory())
              ArCheckbox(
                  text: "Uninstall Aurora",
                  isSelected: state.uninstallAurora,
                  onChange: (_)=>context.read<DisablerBloc>().add(DisableEventCheckDisableServices(uninstallAurora: !state.uninstallAurora))
              ),
            ],
          );
        } else if (state .state ==DisableStateStates.terminal) {
          return const TerminalScreen();
        }

        return placeholder();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ArButton(
        action: () async {
          await arDialog(
              title: "Disable Services",
              subject: "Select the services to be disabled",
              optionalWidget: _selectorWindow(),
              onConfirm: () {
                context.read<DisablerBloc>().add(DisableEventSubmitDisableServices());
              },
              onCancel: (){
                _navigate(context,restart: false);
              });
        },
        title: "Disable Features",
        animate: false,
    );
  }

  _navigate(BuildContext context,{bool restart=true})async{
    if(restart) {
      context.read<DisablerBloc>().add(DisableEventDispose());
      context.read<HomeBloc>().add(HomeEventDispose());
      Phoenix.rebirth(context);
    }
      Navigator.pop(context);
  }
}
