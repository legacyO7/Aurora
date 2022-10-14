import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_bloc.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_event.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWidget extends StatelessWidget{
  const UpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("A new update is available"),
        const SizedBox(height: 20,),
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