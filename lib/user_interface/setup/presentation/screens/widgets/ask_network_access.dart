import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AskNetworkAccess extends StatelessWidget{
  const AskNetworkAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text("Please connect to Internet"),
        ),
        ArButton(
            title: "Try Again",
            action: (){
          context.read<SetupBloc>().add(SetupEventOnUpdate(ignoreUpdate: false));
        })
      ],);
  }
}