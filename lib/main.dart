import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_state.dart';
import 'package:aurora/user_interface/home/presentation/screens/home_screen.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/ar_widgets/cubits/color_cubit.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'shared/data/di/init_aurora.dart';
import 'user_interface/control_panel/presentation/state/disable_services/disable_bloc.dart';
import 'user_interface/home/presentation/state/home_bloc.dart';


void main(List<String> args) async{
  InitAurora initAurora=InitAurora();
  await initAurora.initDI();
  await initAurora.initParser(args);
  WidgetsFlutterBinding.ensureInitialized();
  await initAurora.setWindow();
  await initAurora.initLogger();
  runApp(const Aurora());
}

class Aurora extends StatelessWidget with GlobalMixin{
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ArButtonCubit>()),
        BlocProvider.value(value: sl<ArColorCubit>()),
        BlocProvider.value(value: sl<TerminalBloc>()),
        BlocProvider.value(value: sl<ThemeBloc>()..add(ThemeEventInit())),
      ],
      child: BlocBuilder<ThemeBloc,ThemeState>(
        builder: (_, state)=>
            ResponsiveSizer(
                builder: (context, orientation, deviceType) =>
                  MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Aurora',
                    darkTheme: super.darkTheme(),
                    theme: super.lightTheme(),
                    themeMode: state.arTheme,
                    onGenerateRoute: (settings){
                      switch(settings.name){
                          case '/setup':
                          return MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(providers: [
                              BlocProvider.value(value: sl<SetupBloc>()),
                            ],
                            child: const SetupWizardScreen()),
                          );

                          case '/home':
                          return MaterialPageRoute(
                            builder: (context) =>
                             MultiBlocProvider(
                              providers: [
                                BlocProvider(create:(_)=> sl<HomeBloc>()),
                                BlocProvider.value(value: sl<BatteryManagerBloc>()),
                                BlocProvider.value(value: sl<KeyboardSettingsBloc>()),
                                BlocProvider.value(value: sl<DisableSettingsBloc>()),
                              ],
                              child: const HomeScreen()
                            )
                          );
                        default:
                          return null;
                      }
                    },
                    initialRoute: '/setup',
                  )
            )

      ),
    );
  }
}


