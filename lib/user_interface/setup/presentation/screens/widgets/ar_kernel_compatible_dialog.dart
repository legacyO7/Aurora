import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ar_request_dialog.dart';

class ArKernelCompatibleDialog extends StatelessWidget {
  const ArKernelCompatibleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return arRequestDialog(title: 'Your kernel might support keyboard backlit without using faustus module.\n Would you like to remove faustus module and give it a try?',
        buttonTitle1: "Nope",
        buttonTitle2: "Okay",
        onClickButton1: (){
          context.read<SetupBloc>().add(SetupEventCompatibleKernel());
        },
        onClickButton2: (){
          context.read<SetupBloc>().add(SetupEventCompatibleKernel(removeFaustus: true));
        }
    );
  }
}
