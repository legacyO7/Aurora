
import 'package:aurora/user_interface/home/presentation/screens/home_screen.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_screen.dart';
import 'package:aurora/user_interface/setup/presentation/screens/widgets/setup_splash.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_state.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/update_window.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({Key? key}) : super(key: key);

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {


  @override
  initState() {
    context.read<SetupBloc>().add(EventSWInit());
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
            child: BlocListener <SetupBloc,SetupState>(
              listener: (BuildContext context, state) {
                if(state is SetupCompatibleState){
                  Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()))
                  );
                }
              },
              child: BlocBuilder<SetupBloc,SetupState>(
                builder: (BuildContext context, state) {

                  if(state is SetupInitState ) {
                    return const Text("checking compatibility...");
                  }

                  if(state is SetupConnectedState ) {
                    return const Text("checking for updates...");
                  }

                  if(state is SetupIncompatibleState || state is SetupPermissionState) {
                    return const SetupScreen();
                  }

                  if(state is SetupUpdateAvailableState ) {
                    return UpdateWidget(changelog: state.changelog,);
                  }

                  if(state is SetupCompatibleState) {
                    return const Text("initializing...");
                  }

                    return const Text("something is really wrong ;(");

                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}