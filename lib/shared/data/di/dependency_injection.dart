part of '../../utility/init_aurora.dart';

final sl = GetIt.I;

class DependencyInjection{
  static Future initDI() async {
    sl.allowReassignment = true;

    sl.registerLazySingleton(() => HomeBloc(sl(), sl()));
    sl.registerLazySingleton(() => DisableSettingsBloc(sl()));
    sl.registerLazySingleton(() => TerminalBloc());
    sl.registerLazySingleton(() => KeyboardSettingsBloc(sl(), sl()));
    sl.registerLazySingleton(() => BatteryManagerBloc(sl()));
    sl.registerLazySingleton(() => SetupBloc(sl(), sl(), sl()));
    sl.registerLazySingleton(() => ThemeBloc(sl()));
    sl.registerLazySingleton(() => ProfilesBloc(sl()));
    sl.registerLazySingleton(() => ArButtonCubit());
    sl.registerLazySingleton(() => ArColorCubit());

    sl.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl(sl()));
    sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl(), sl(), sl(),sl(), sl(),sl()));
    sl.registerLazySingleton<SetupRepo>(() => SetupRepoImpl(sl(), sl(), sl(),sl(), sl()));
    sl.registerLazySingleton<KeyboardSettingsRepo>(() => KeyboardSettingsRepoImpl(sl(), sl()));
    sl.registerLazySingleton<BatteryManagerRepo>(() => BatteryManagerRepoImpl(sl(), sl(),sl(),sl()));
    sl.registerLazySingleton<DisableSettingsRepo>(() => DisableSettingsRepoImpl(sl(), sl(),sl(),sl()));
    sl.registerLazySingleton<SetupSource>(() => SetupSourceImpl(sl()));
    sl.registerLazySingleton<TerminalSource>(() => TerminalSourceImpl());
    sl.registerLazySingleton<PermissionManager>(() => PermissionManagerImpl(sl(),sl(),sl()));
    sl.registerLazySingleton<IOManager>(() => IOManagerImpl());
    sl.registerLazySingleton<ServiceManager>(() => ServiceManagerImpl(sl(),sl()));
    sl.registerLazySingleton<FileManager>(() => FileManagerImpl(sl()));
    sl.registerLazySingleton<IsarManager>(() => IsarManagerImpl(sl()));
    sl.registerLazySingleton<IsarDelegate>(() => IsarDelegateImpl(sl()));
    sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()));
    sl.registerLazySingleton<RemoteIOManager>(() => RemoteIOManagerImpl(sl()));

    sl.registerLazySingleton<Dio>(() => Dio());
    sl.registerLazySingleton<GlobalConfig>(() => GlobalConfig());

    ArLogger();
  }
}