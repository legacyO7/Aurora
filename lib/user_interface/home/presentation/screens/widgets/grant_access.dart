import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/utility/ar_widgets/arbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context){
  return Center(
    child: ArButton(title: "Grant Access",
        isSelected: true,
        action: (){
          context.read<HomeCubit>().requestAccess();
    }),
  );
}