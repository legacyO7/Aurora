
import 'package:aurora/user_interface/home/presentation/screens/home_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/setup_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_state.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({Key? key}) : super(key: key);

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {


  @override
  initState() {
    context.read<SetupWizardCubit>().initSetup();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Constants.kScaffoldKey,
      body: Center(
        child: BlocListener <SetupWizardCubit,SetupWizardState>(
          listener: (BuildContext context, state) {
            if(state is SetupWizardCompatibleState){
              Future.delayed(const Duration(milliseconds: 500)).then((value) =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()))
              );
            }
          },
          child: BlocBuilder<SetupWizardCubit,SetupWizardState>(
            builder: (BuildContext context, state) {
              if(state is SetupWizardInitState ) {
                return const Text("Checking Compatibility...");
              }
              else if(state is SetupWizardIncompatibleState) {
              return const SetupScreen();
              }
              else{
                return const Text("Lets do this!");
              }
            },
          ),
        ),
      ),
    );
  }
}