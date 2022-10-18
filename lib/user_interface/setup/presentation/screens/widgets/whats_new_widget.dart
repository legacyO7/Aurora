import 'package:aurora/user_interface/setup/presentation/screens/widgets/changelog_container.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatsNewWidget extends StatelessWidget{
  const WhatsNewWidget({required this.changelog, super.key});

  final String changelog;

  @override
  Widget build(BuildContext context) {
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     mainAxisSize: MainAxisSize.min,
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
     Center(child: Text("Whats new in v${Constants.arVersion}")),
     changelogContainer(changelog: changelog),
     Center(
       child: ArButton(
           title: "Okay",
           isSelected: true,
           action: (){
             context.read<SetupBloc>().add(SetupEventOnUpdate(ignoreUpdate: false));
           }),
     )
   ],);
  }

}