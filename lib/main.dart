import 'dart:io';

import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/control_panel/state/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/setup_wizard_screen.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/arbutton_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'user_interface/home/presentation/state/home_cubit.dart';

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
       BlocProvider.value(value: sl<SetupWizardBloc>()),
       BlocProvider.value(value: sl<HomeCubit>()),
       BlocProvider.value(value: sl<UninstallerBloc>()),
       BlocProvider.value(value: sl<KeyboardSettingsBloc>()),
       BlocProvider.value(value: sl<BatteryManagerBloc>()),
       BlocProvider.value(value: sl<TerminalCubit>()),
       BlocProvider.value(value: sl<ArButtonCubit>()),
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
