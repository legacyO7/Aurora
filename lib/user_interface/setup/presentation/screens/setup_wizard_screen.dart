
import 'package:aurora/user_interface/control_panel/presentation/screens/widgets/theme_button.dart';
import 'package:aurora/user_interface/home/presentation/screens/home_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/screens/widgets/ar_kernel_compatible_dialog.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_state.dart';
import 'package:aurora/utility/ar_widgets/ar_top_buttons.dart';
import 'package:aurora/utility/constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
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
      body: Stack(
        children: [
          MoveWindow(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ThemeButton(),
                setupSplash(),
                Flexible(
                  child: BlocListener <SetupBloc,SetupState>(
                    listener: (BuildContext context, state) {
                      if(state is SetupCompatibleState|| state is SetupMainlineCompatibleState){
                        Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()))
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

                        if(state is SetupAskNetworkAccessState ) {
                          return const AskNetworkAccess();
                        }

                        if(state is SetupIncompatibleState || state is SetupPermissionState || state is SetupBatteryManagerCompatibleState) {
                          return const SetupScreen();
                        }

                        if(state is SetupWhatsNewState ) {
                          return WhatsNewWidget(changelog: state.changelog,);
                        }

                        if(state is SetupUpdateAvailableState ) {
                          return UpdateWidget(changelog: state.changelog,);
                        }

                        if(state is SetupCompatibleState) {
                          return const Text("initializing...");
                        }

                        if(state is SetupDisableFaustusState) {
                          return const Text("disabling faustus module...");
                        }

                        if(state is SetupCompatibleKernel) {
                          return const ArKernelCompatibleDialog();
                        }

                        if(state is SetupMainlineCompatibleState) {
                          return const Text("using mainline kernel module, nothing to install");
                        }

                          return const Text("something is really wrong ;(");

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            child:
          ArWindowButtons(),)
        ],
      ),
    );
  }
}