import 'dart:io';

import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/battery_manager/presentation/state/batter_manager_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/setup_wizard_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'user_interface/home/presentation/state/home_cubit.dart';
import 'user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';

void main() async{
  await initDI();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux) {
    setWindowMaxSize(const Size(1000, 600));
    setWindowMinSize(const Size(1000, 600));
  }
  runApp(const Aurora());
}

class Aurora extends StatelessWidget {
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider.value(value: serviceLocator<SetupWizardCubit>()),
       BlocProvider.value(value: serviceLocator<HomeCubit>()),
       BlocProvider.value(value: serviceLocator<KeyboardSettingsCubit>()),
       BlocProvider.value(value: serviceLocator<BatteryManagerCubit>()),
      ],
      child: MaterialApp(
        title: 'Aurora',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        home: const SetupWizardScreen(),
      ),
    );
  }
}
