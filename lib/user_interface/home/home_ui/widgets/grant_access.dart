import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context){
  return Center(
    child: button(title: "Grant Access",
        isSelected: true,
        context: context,
        action: (){
          context.read<HomeCubit>().requestAccess();
    }),
  );
}