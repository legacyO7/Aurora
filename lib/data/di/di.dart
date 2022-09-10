
import 'package:aurora/data/di/shared_preference/pref_repo.dart';
import 'package:aurora/data/di/shared_preference/pref_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/control_panel_state/control_panel_cubit.dart';
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.I;

Future initDI() async{
  serviceLocator.allowReassignment=true;
  serviceLocator.registerLazySingleton(() => HomeCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ControlPanelCubit(serviceLocator(),serviceLocator()));

  serviceLocator.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl());
  serviceLocator.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(serviceLocator()));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}