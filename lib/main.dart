import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/control_panel/state/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/theme_event.dart';
import 'package:aurora/user_interface/control_panel/state/theme_state.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'user_interface/home/presentation/state/home_bloc.dart';


void main() async{
  await initDI();
  WidgetsFlutterBinding.ensureInitialized();

  setWindowMaxSize(const Size(1000, 600));
  setWindowMinSize(const Size(1000, 600));

  runApp(const Aurora());


  doWhenWindowReady(() {
    const initialSize = Size(1000, 600);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });

}

class Aurora extends StatelessWidget {
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider.value(value: sl<SetupBloc>()),
       BlocProvider.value(value: sl<HomeBloc>()),
       BlocProvider.value(value: sl<UninstallerBloc>()),
       BlocProvider.value(value: sl<KeyboardSettingsBloc>()),
       BlocProvider.value(value: sl<BatteryManagerBloc>()),
       BlocProvider.value(value: sl<TerminalBloc>()),
       BlocProvider.value(value: sl<ThemeBloc>()..add(ThemeEventInit())),
       BlocProvider.value(value: sl<ArButtonCubit>()),
      ],
      child: BlocBuilder<ThemeBloc,ThemeState>(
        builder: (_, state)=>
            MaterialApp(
              title: 'Aurora',
              darkTheme: ThemeData.dark(),
              theme: ThemeData.light(),
              themeMode: state.arTheme,
              home: const SetupWizardScreen(),
            )
      ),
    );
  }
}
