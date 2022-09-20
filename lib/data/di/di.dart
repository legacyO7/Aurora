
import 'package:aurora/user_interface/battery_manager/presentation/state/batter_manager_cubit.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo_impl.dart';
import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/state/keyboard_settings_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/data/repository/setup_wizard_source_impl.dart';
import 'package:aurora/user_interface/setup_wizard/data/source/setup_wizard_source.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo_impl.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_cubit.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_preference/pref_repo.dart';
import '../shared_preference/pref_repo_impl.dart';

final serviceLocator = GetIt.I;

Future initDI() async{
  serviceLocator.allowReassignment=true;

  serviceLocator.registerLazySingleton(() => HomeCubit(serviceLocator(),serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton(() => TerminalCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(() => KeyboardSettingsCubit(serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton(() => BatteryManagerCubit(serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetupWizardCubit(serviceLocator(),serviceLocator(),serviceLocator()));

  serviceLocator.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl());
  serviceLocator.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<SetupWizardRepo>(() => SetupWizardRepoImpl(serviceLocator()));

  serviceLocator.registerLazySingleton<SetupWizardSource>(() => SetupWizardSourceImpl());


  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}