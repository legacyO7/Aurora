import 'package:aurora/user_interface/control_panel/state/control_panel_cubit.dart';
import 'package:aurora/user_interface/control_panel/state/control_panel_state.dart';
import 'package:aurora/utility/ardialog.dart';
import 'package:aurora/utility/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UninstallButton extends StatelessWidget{
  const UninstallButton({super.key});

  Widget _selecterWindow(){
   return BlocBuilder<ControlPanelCubit,ControlPanelState>(
        builder: (BuildContext context, state) {
      if(state is ControlPanelStateInit){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              title:  Text("Disable charging threshold"),
              value: state.disableThreshold,
              onChanged: (_){
                context.read<ControlPanelCubit>().setDisableService(disableThreshold: !state.disableThreshold);
              },),
            CheckboxListTile(
              title: const Text("Disable faustus module"),
              value: state.disableFaustusModule,
              onChanged: (_){
                context.read<ControlPanelCubit>().setDisableService(disableFaustusModule:!state.disableFaustusModule);
              },)
          ],
        );

      }else{
        return placeholder();
      }

        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async{
          arDialog(
              context: context,
              title: "Disable Services",
              subject: "Select the services to be disabled",
              optionalWidget: _selecterWindow(),
              onConfirm: ()async {
                await context.read<ControlPanelCubit>().disableServices();
              }
          );
        },
        icon: const Icon(Icons.delete_outline)
    );
  }
}



