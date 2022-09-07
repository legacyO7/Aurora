import 'package:aurora/user_interface/control_panel/control_panel_ui/control_panel_screen.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/home/home_ui/widgets/grant_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {

  @override
  void initState() {
    context.read<HomeCubit>().requestAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: BlocBuilder<HomeCubit,HomeState>
                (builder: (context,state){
                if(state is AccessGranted && (state.hasRootAccess)) {
                  return const ControlPanelScreen();
                } else {
                  return grantAccess(context);
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}