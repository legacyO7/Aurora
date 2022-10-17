import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_bloc.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_event.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWidget extends StatelessWidget{
  const UpdateWidget({super.key,required this.changelog});

  final String changelog;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("A new update is available"),
        Flexible(child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration:  BoxDecoration(
                border: Border.all(color: Constants.arColor)
            ),
            child: SingleChildScrollView(child: Text(changelog)))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ArButton(
                isSelected: true,
                title: "Download\nupdate", action: (){
              context.read<HomeCubit>().launchUrl();
            }),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: ArButton(title: "Ignore", action: (){
                context.read<SetupWizardBloc>().add(EventSWIgnoreUpdate());
              }),
            ),
          ],
        )

      ],
    );
  }

}