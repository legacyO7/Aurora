import 'package:aurora/user_interface/home/presentation/screens/widgets/privileged_run_button.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context,{bool runAsRoot=false}){
  return Column(
    children: [
      Expanded(
        flex: 7,
        child: Center(
          child: ArButton(title: "Grant Access",
              isSelected: true,
              action: ()=> context.read<HomeBloc>().add(HomeEventRequestAccess())
          ),
        ),
      ),
      if(runAsRoot)
      const Expanded(child:  Center(
        child: PrivilegedRunButton()
      ),)
    ],
  );
}