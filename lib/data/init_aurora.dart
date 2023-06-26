
import 'package:args/args.dart';
import 'package:aurora/user_interface/control_panel/data/permission_manager.dart';
import 'package:aurora/user_interface/control_panel/data/permission_manager_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/keyboard_settings/keyboard_settings_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/keyboard_settings/keyboard_settings_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';
import 'package:aurora/user_interface/home/data/io_manager.dart';
import 'package:aurora/user_interface/home/data/io_manager_impl.dart';
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
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate_impl.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/utility/ar_bloc_observer.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/user_interface/setup/data/source/dio_client.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'shared_preference/pref_repo.dart';
import 'shared_preference/pref_repo_impl.dart';

final sl = GetIt.I;

class InitAurora {

  Future initDI() async {
    sl.allowReassignment = true;

    sl.registerLazySingleton(() => HomeBloc(sl(), sl()));
    sl.registerLazySingleton(() => DisablerBloc(sl()));
    sl.registerLazySingleton(() => TerminalBloc());
    sl.registerLazySingleton(() => KeyboardSettingsBloc(sl(), sl()));
    sl.registerLazySingleton(() => BatteryManagerBloc(sl()));
    sl.registerLazySingleton(() => SetupBloc(sl(), sl(), sl(), sl(), sl()));
    sl.registerLazySingleton(() => ThemeBloc(sl()));
    sl.registerLazySingleton(() => ArButtonCubit());

    sl.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl(sl()));
    sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl(), sl(), sl()));
    sl.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(sl()));
    sl.registerLazySingleton<SetupRepo>(() => SetupRepoImpl(sl(), sl(), sl()));
    sl.registerLazySingleton<KeyboardSettingsRepo>(() => KeyboardSettingsRepoImpl(sl(), sl()));
    sl.registerLazySingleton<BatteryManagerRepo>(() => BatteryManagerRepoImpl(sl(), sl()));
    sl.registerLazySingleton<DisablerRepo>(() => DisablerRepoImpl(sl(), sl()));
    sl.registerLazySingleton<TerminalDelegate>(() => TerminalDelegateImpl(sl(), sl()));
    sl.registerLazySingleton<SetupSource>(() => SetupSourceImpl(sl()));
    sl.registerLazySingleton<TerminalSource>(() => TerminalSourceImpl(sl()));
    sl.registerLazySingleton<PermissionManager>(() => PermissionManagerImpl(sl()));
    sl.registerLazySingleton<IOManager>(() => IOManagerImpl());

    sl.registerLazySingleton<DioClient>(() => DioClientImpl(sl()));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<Dio>(() => Dio());
    sl.registerLazySingleton<ArLogger>(() => ArLogger());
    sl.registerLazySingleton<GlobalConfig>(() => GlobalConfig());
  }


  Future setWindow() async{

    Size initialSize = const Size(1000,600);
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
        size: initialSize,
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        maximumSize:initialSize,
        minimumSize: initialSize
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });


    doWhenWindowReady(() {
      appWindow.minSize = initialSize;
      appWindow.maxSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });

  }

  void errorRecorder(){

    ArLogger arLogger= sl<ArLogger>()..initialize();

    FlutterError.onError= (error){
      arLogger.log(data: error.toString());
    };

    PlatformDispatcher.instance.onError = (error, stackTrace){
      arLogger.log(data: error.toString(),stackTrace: stackTrace);
      return true;
    };

    Bloc.observer=AppBlocObserver();
  }

  void initParser(List<String> args){
    var parser = ArgParser();
    parser.addFlag('log',defaultsTo: false);
    var result = parser.parse(args);
    Constants.isLoggingEnabled=result['log'];
  }

}