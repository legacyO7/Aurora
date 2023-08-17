import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GitButton extends StatelessWidget{
  const GitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ArButton(
        action: () => context.read<HomeBloc>().add(HomeEventLaunch()),
        title: "Visit Home",
        animate: false,
    );
  }

}
