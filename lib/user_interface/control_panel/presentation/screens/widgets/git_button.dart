import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GitButton extends StatelessWidget{
  const GitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<HomeBloc>().add(EventHLaunchUrl()),
        icon: const Icon(Icons.home));
  }

}
