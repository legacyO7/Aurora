
import 'package:aurora/user_interface/control_panel/presentation/state/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo_impl.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source_impl.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo_impl.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source_impl.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:aurora/user_interface/setup/data/source/dio_client.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_preference/pref_repo.dart';
import '../shared_preference/pref_repo_impl.dart';

final sl = GetIt.I;

Future initDI() async{
  sl.allowReassignment=true;

  sl.registerLazySingleton(() => HomeBloc(sl(),sl()));
  sl.registerLazySingleton(() => UninstallerBloc(sl(),sl()));
  sl.registerLazySingleton(() => TerminalBloc());
  sl.registerLazySingleton(() => KeyboardSettingsBloc(sl()));
  sl.registerLazySingleton(() => BatteryManagerBloc(sl(),sl()));
  sl.registerLazySingleton(() => SetupBloc(sl(),sl(),sl(),sl()));
  sl.registerLazySingleton(() => ThemeBloc(sl()));
  sl.registerLazySingleton(() => ArButtonCubit());

  sl.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl(sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(sl()));
  sl.registerLazySingleton<SetupRepo>(() => SetupRepoImpl(sl()));

  sl.registerLazySingleton<SetupSource>(() => SetupSourceImpl(sl()));
  sl.registerLazySingleton<TerminalSource>(() => TerminalSourceImpl());

  sl.registerLazySingleton<DioClient>(() => DioClientImpl(sl()));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<GlobalConfig>(() => GlobalConfig());
}