import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/utility/ksnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context){
  return Center(
    child: InkWell(
      onTap: (){
        context.read<HomeCubit>().requestAccess();
        kSnackBar(context: context, text: "initializing", rightWidget: const CircularProgressIndicator());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: const Text("Grant Access"),
      ),
    ),
  );
}