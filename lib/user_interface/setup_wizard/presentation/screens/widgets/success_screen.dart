import 'package:aurora/user_interface/home/presentation/screens/home_screen.dart';
import 'package:aurora/utility/button.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget{
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
    child: button(title: "Success", action: (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    }, context: context),
    );
  }
}