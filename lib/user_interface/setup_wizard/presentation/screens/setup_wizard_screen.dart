
import 'package:aurora/user_interface/home/presentation/screens/home_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/setup_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/setup_splash.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          setupSplash(),
          Flexible(
            child: BlocListener <SetupWizardCubit,SetupWizardState>(
              listener: (BuildContext context, state) {
                if(state is SetupWizardCompatibleState){
                  Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()))
                  );
                }
              },
              child: BlocBuilder<SetupWizardCubit,SetupWizardState>(
                builder: (BuildContext context, state) {
                  if(state is SetupWizardInitState ) {
                    return const Text("checking compatibility...");
                  }
                  else if(state is SetupWizardIncompatibleState) {
                  return const SetupScreen();
                  }
                  else{
                    return const Text("initializing...");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}