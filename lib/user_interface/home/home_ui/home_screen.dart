import 'package:aurora/user_interface/control_panel/control_panel_ui/control_panel_screen.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/home/home_ui/widgets/grant_access.dart';
import 'package:aurora/user_interface/keyboard_settings/keyboard_settings_state/keyboard_settings_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
            Stack(
              children: [
                SvgPicture.asset(
                    'assets/images/icon.svg',
                    color: context.watch<KeyboardSettingsCubit>().selectedColor,
                    height:85,
                ),
                Opacity(
                  opacity: .5,
                  child: Image.asset('assets/images/icon.png',
                    height:85
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                const Text("Aurora",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text("\tv${Constants.arVersion}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<HomeCubit,HomeState>
                  (builder: (context,state){
                  if(state is AccessGranted && (state.hasRootAccess)) {
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