import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/setup/presentation/screens/widgets/changelog_container.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
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
        Row(
          children: [
            changelogContainer(changelog: changelog),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ArButton(
                isSelected: true,
                title: "Download\nupdate", action:() => context.read<HomeBloc>().add(HomeEventLaunch())),
            ArButton(
                edgeInsets: const EdgeInsets.only(left: 10),
                title: "Ignore",
                action: (){
              context.read<SetupBloc>().add(SetupEventOnUpdate(ignoreUpdate: true));
            }),
          ],
        )

      ],
    );
  }

}