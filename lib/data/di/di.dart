
import 'package:aurora/user_interface/control_panel/state/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_bloc.dart';
import 'package:aurora/user_interface/control_panel/state/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo_impl.dart';
import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/data/repository/setup_wizard_source_impl.dart';
import 'package:aurora/user_interface/setup_wizard/data/repository/setup_wizard_source.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo_impl.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_bloc.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source_impl.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_widgets/arbutton_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/data/source/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_preference/pref_repo.dart';
import '../shared_preference/pref_repo_impl.dart';

final sl = GetIt.I;

Future initDI() async{
  sl.allowReassignment=true;

  sl.registerLazySingleton(() => HomeCubit(sl(),sl()));
  sl.registerLazySingleton(() => UninstallerBloc(sl(),sl()));
  sl.registerLazySingleton(() => TerminalBloc());
  sl.registerLazySingleton(() => KeyboardSettingsBloc(sl()));
  sl.registerLazySingleton(() => BatteryManagerBloc(sl()));
  sl.registerLazySingleton(() => SetupWizardBloc(sl(),sl(),sl()));
  sl.registerLazySingleton(() => ArButtonCubit());

  sl.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl(sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(sl()));
  sl.registerLazySingleton<SetupWizardRepo>(() => SetupWizardRepoImpl(sl()));

  sl.registerLazySingleton<SetupWizardSource>(() => SetupWizardSourceImpl(sl()));
  sl.registerLazySingleton<TerminalSource>(() => TerminalSourceImpl());

  sl.registerLazySingleton<DioClient>(() => DioClientImpl());

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}