import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggerButton extends StatelessWidget {
  const LoggerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArButton(
        animate: false,
        title: "${Constants.globalConfig.isLoggingEnabled?'Dis':'En'}able logging", action: (){
      context.read<HomeBloc>().add(HomeEventEnableLogging());
      Navigator.pop(context);
    });
  }
}
