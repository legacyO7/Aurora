import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_screen.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/home/presentation/screens/widgets/grant_access.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/home_bloc.dart';
import '../state/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {

  @override
  void initState() {
    context.read<HomeBloc>().add(HomeEventRequestAccess());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Aurora",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: context.watch<KeyboardSettingsBloc>().selectedColor),),
                  Text("\tv${Constants.arVersion}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<HomeBloc,HomeState>
                  (builder: (context,state){
                  if(state is AccessGranted && (state.hasAccess)) {
                    return const ControlPanelScreen();
                  } else {
                    return grantAccess(context);
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}