
import 'dart:io';

import 'package:args/args.dart';
import 'package:aurora/data/io/file_manager/file_manager.dart';
import 'package:aurora/data/io/file_manager/file_manager_impl.dart';
import 'package:aurora/data/io/service_manager/service_manager.dart';
import 'package:aurora/data/io/service_manager/service_manager_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/keyboard_settings/keyboard_settings_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/keyboard_settings/keyboard_settings_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo_impl.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/battery_manager/batter_manager_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/keyboard_settings/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/theme/theme_bloc.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo_impl.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source_impl.dart';
import 'package:aurora/user_interface/setup/data/source/dio_client.dart';
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
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'io/io_manager/io_manager.dart';
import 'io/io_manager/io_manager_impl.dart';
import 'io/permission_manager/permission_manager.dart';
import 'io/permission_manager/permission_manager_impl.dart';
import 'shared_preference/pref_repo.dart';
import 'shared_preference/pref_repo_impl.dart';

final sl = GetIt.I;

class InitAurora with GlobalMixin {

  Future initDI() async {
    sl.allowReassignment = true;

    sl.registerLazySingleton(() => HomeBloc(sl(), sl(),sl()));
    sl.registerLazySingleton(() => DisablerBloc(sl()));
    sl.registerLazySingleton(() => TerminalBloc());
    sl.registerLazySingleton(() => KeyboardSettingsBloc(sl(), sl()));
    sl.registerLazySingleton(() => BatteryManagerBloc(sl()));
    sl.registerLazySingleton(() => SetupBloc(sl(), sl(), sl(), sl(), sl()));
    sl.registerLazySingleton(() => ThemeBloc(sl()));
    sl.registerLazySingleton(() => ArButtonCubit());

    sl.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl(sl()));
    sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl(), sl(), sl(),sl()));
    sl.registerLazySingleton<PrefRepo>(() => PrefRepoImpl(sl()));
    sl.registerLazySingleton<SetupRepo>(() => SetupRepoImpl(sl(), sl(), sl(),sl()));
    sl.registerLazySingleton<KeyboardSettingsRepo>(() => KeyboardSettingsRepoImpl(sl(), sl()));
    sl.registerLazySingleton<BatteryManagerRepo>(() => BatteryManagerRepoImpl(sl(), sl(),sl(),sl(),sl()));
    sl.registerLazySingleton<DisablerRepo>(() => DisablerRepoImpl(sl(), sl(),sl(),sl(),sl()));
    sl.registerLazySingleton<TerminalDelegate>(() => TerminalDelegateImpl(sl(), sl()));
    sl.registerLazySingleton<SetupSource>(() => SetupSourceImpl(sl()));
    sl.registerLazySingleton<TerminalSource>(() => TerminalSourceImpl());
    sl.registerLazySingleton<PermissionManager>(() => PermissionManagerImpl(sl(),sl(),sl()));
    sl.registerLazySingleton<IOManager>(() => IOManagerImpl());
    sl.registerLazySingleton<ServiceManager>(() => ServiceManagerImpl(sl(),sl()));
    sl.registerLazySingleton<FileManager>(() => FileManagerImpl(sl()));

    sl.registerLazySingleton<DioClient>(() => DioClientImpl(sl()));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<Dio>(() => Dio());
    sl.registerLazySingleton<GlobalConfig>(() => GlobalConfig());

    ArLogger();
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

  Future initLogger() async {

    if(canLog()){

      ArLogger.initialize();
      await sl<HomeRepo>().initLog();

      FlutterError.onError = (error) async {
        await ArLogger.log(data: error.toString());
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        ArLogger.log(data: error ,stackTrace: stackTrace);
        return true;
      };

      Bloc.observer = AppBlocObserver();
    }
  }

  Future initParser(List<String> args) async{
    var parser = ArgParser();
    parser.addFlag('log',defaultsTo: false);
    parser.addFlag('version');
    ArgResults? result;
    try {
      result = parser.parse(args);
    }catch(e,stackTrace){
      stderr.writeln("unknown argument");
      ArLogger.log(data: e,stackTrace: stackTrace);
      exit(0);
    }
    await validateArgs(result);
  }


  Future validateArgs(ArgResults results) async{

    List<String> cliArgs=['version'];
    List<String> appArgs=['log'];

    Map<String, Function> argExecutables={
      'version': () async => stdout.writeln(await sl<HomeRepo>().getVersion()),
      'log': () => Constants.isLoggingEnabled=results.wasParsed('log')
    };


    for (var arg in [...cliArgs,...appArgs]){
      if(results.wasParsed(arg)){
        await argExecutables[arg]!.call();
      }
    }

    if(results.arguments.isNotEmpty&&(!results.arguments.any((element) => appArgs.contains(element.replaceAll('-', ''))))){
      exit(0);
    }

  }

}