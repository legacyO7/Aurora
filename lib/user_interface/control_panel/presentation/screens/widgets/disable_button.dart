import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_state.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_widgets.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisableButton extends StatelessWidget with GlobalMixin {
  const DisableButton({super.key});

  Widget _selectorWindow() {
    return BlocListener<DisablerBloc,Equatable>(
      listener: (BuildContext context, state) {
        if(state is DisableProcessCompletedState) {
          _navigate(context);
        }
      },
      child: BlocBuilder<DisablerBloc, Equatable>
        (builder: (BuildContext context, state) {

        if (state is DisableInitState) {
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
        } else if (state is DisableTerminalState) {
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
        tooltip: "Disable Features",
        icon: const Icon(Icons.delete_outline));
  }

  _navigate(BuildContext context,{bool restart=true})async{
    if(restart) {
      context.read<DisablerBloc>().add(DisableEventDispose());
      context.read<HomeBloc>().add(HomeEventDispose());
    }
      Navigator.pop(context);
  }
}
