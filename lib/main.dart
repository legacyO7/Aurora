import 'package:aurora/utility/warmup.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_state.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'user_interface/home/presentation/state/home_bloc.dart';


void main() async{
  WarmUp warmUp=WarmUp();
  await warmUp.initDI();
  WidgetsFlutterBinding.ensureInitialized();
  await warmUp.setWindow();
  warmUp.errorRecorder();
  runApp(Phoenix(child: const Aurora()));
}

class Aurora extends StatelessWidget with GlobalMixin{
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider.value(value: sl<SetupBloc>()),
       BlocProvider.value(value: sl<HomeBloc>()),
       BlocProvider.value(value: sl<DisablerBloc>()),
       BlocProvider.value(value: sl<KeyboardSettingsBloc>()),
       BlocProvider.value(value: sl<BatteryManagerBloc>()),
       BlocProvider.value(value: sl<TerminalBloc>()),
       BlocProvider.value(value: sl<ThemeBloc>()..add(ThemeEventInit())),
       BlocProvider.value(value: sl<ArButtonCubit>()),
      ],
      child: BlocBuilder<ThemeBloc,ThemeState>(
        builder: (_, state)=>
            ResponsiveSizer(
                builder: (context, orientation, deviceType) =>
                  MaterialApp(
                    title: 'Aurora',
                    darkTheme: super.darkTheme(),
                    theme: super.lightTheme(),
                    themeMode: state.arTheme,
                    home: const SetupWizardScreen(),
                  )
            )

      ),
    );
  }
}
