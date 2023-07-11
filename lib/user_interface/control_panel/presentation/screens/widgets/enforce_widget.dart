import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/ar_widgets/ar_dialog.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnforceWidget extends StatelessWidget with GlobalMixin {
  const EnforceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMainLine()? ArButton(
        animate: false,
        title: "Enforce Faustus", action: (){
      arDialog(
          title: "Enforce Faustus?",
          subject: "This will disable and blacklist\n- asus_wmi\n- asus_nb_wmi\nand force Aurora to run in faustus mode",
          onConfirm: (){
            context.read<HomeBloc>().add(HomeEventEnforceFaustus());
          });
    }):const SizedBox();
  }
}
