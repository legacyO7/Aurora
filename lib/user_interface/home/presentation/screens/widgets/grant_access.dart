import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context){
  return Center(
    child: ArButton(title: "Grant Access",
        isSelected: true,
        action: ()=> context.read<HomeBloc>().add(HomeEventRequestAccess())
    ),
  );
}