import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/home/presentation/screens/home_widgets.dart';
import 'package:aurora/user_interface/home/presentation/screens/widgets/home_top_bar.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
    context.read<HomeBloc>()
      ..add(HomeEventInit())
      ..setAppHeight();
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
            Flexible(
              child: MoveWindow(
                child: const HomeTopBar(),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w),
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