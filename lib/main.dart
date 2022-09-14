import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/battery_manager/battery_manager_state/batter_manager_cubit.dart';
import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/home/home_ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  initDI();
  runApp(const Aurora());
}

class Aurora extends StatelessWidget {
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider.value(value: serviceLocator<HomeCubit>()),
       BlocProvider.value(value: serviceLocator<ControlPanelCubit>()),
       BlocProvider.value(value: serviceLocator<BatteryManagerCubit>()),
      ],
      child: MaterialApp(
        title: 'Aurora',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
