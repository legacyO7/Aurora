
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurora/user_interface/keyboard_settings/keyboard_settings_state/keyboard_settings_cubit.dart';

import '../../user_interface/battery_manager/battery_manager_state/batter_manager_cubit.dart';
import '../shared_preference/pref_repo.dart';
import '../shared_preference/pref_repo_impl.dart';

final serviceLocator = GetIt.I;

Future initDI() async{
  serviceLocator.allowReassignment=true;

  serviceLocator.registerLazySingleton(() => HomeCubit(serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton(() => KeyboardSettingsCubit(serviceLocator(),serviceLocator()));
  serviceLocator.registerLazySingleton(() => BatteryManagerCubit(serviceLocator(),serviceLocator()));

  serviceLocator.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl());
  serviceLocator.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(serviceLocator()));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}