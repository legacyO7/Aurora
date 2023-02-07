import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_state.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'user_interface/home/presentation/state/home_bloc.dart';


void main() async{
  await initDI();
  WidgetsFlutterBinding.ensureInitialized();

  Size initialSize = ArWindow().setWindowSize();
  setWindowMaxSize(initialSize);
  setWindowMinSize(initialSize);

  runApp(const Aurora());

  doWhenWindowReady(() {
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}


class ArWindow with GlobalMixin{
  Size setWindowSize() {
    if(super.isMainLineCompatible()) {
      return const Size(1000,680);
    } else {
      return const Size(1000,600);
    }
  }
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
