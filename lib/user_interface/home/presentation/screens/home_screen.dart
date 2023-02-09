import 'package:aurora/user_interface/control_panel/presentation/screens/control_panel_widgets.dart';
import 'package:aurora/user_interface/home/presentation/screens/home_widgets.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:aurora/utility/ar_widgets/ar_top_buttons.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/home_bloc.dart';
import '../state/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> with GlobalMixin {

  @override
  void initState() {
    context.read<HomeBloc>()
      ..add(HomeEventRequestAccess())
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const ArWindowButtons(),
                  Column(
                    children: [
                      Text("Aurora",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: context.selectedColor),),
                      Text("\tv${Constants.globalConfig.arVersion}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: context.selectedColorWithAlpha,
                              width: 3.0
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(15.0)
                          ),
                          color: context.selectedColorWithAlpha
                        ),
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                        child: Text(super.isMainLine()?"Mainline":"Faustus"),
                      )
                    ],
                  ),
                  const SizedBox()
                ],),
              ),
            ),
            Expanded(
              flex: 5,
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