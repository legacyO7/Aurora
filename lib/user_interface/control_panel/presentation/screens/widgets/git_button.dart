import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GitButton extends StatelessWidget{
  const GitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          context.read<HomeCubit>().launchUrl();
        },
        icon: const Icon(Icons.home));
  }

}
