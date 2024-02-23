
import 'dart:ui';

import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_delegate_impl.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager_impl.dart';
import 'package:aurora/shared/utility/args_parser.dart';
import 'package:aurora/user_interface/battery_manager/data/repositories/battery_manager_repo.dart';
import 'package:aurora/user_interface/battery_manager/data/repositories/battery_manager_repo_impl.dart';
import 'package:aurora/user_interface/battery_manager/presentation/state/batter_manager_bloc.dart';
import 'package:aurora/user_interface/disable_services/presentation/state/disable_bloc.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo_impl.dart';
import 'package:aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_mainline_repo_impl.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo_impl.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_bloc.dart';
import 'package:aurora/user_interface/preferences/presentation/state/preferences_bloc.dart';
import 'package:aurora/user_interface/profiles/domain/repositories/profile_repo.dart';
import 'package:aurora/user_interface/profiles/domain/repositories/profile_repo_impl.dart';
import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/data/repository/setup_source_impl.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo_impl.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/user_interface/theme/presentation/state/theme_bloc.dart';
import 'package:aurora/utility/ar_bloc_observer.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

import '../data/shared_data.dart';
import '../disable_settings/shared_disable_services.dart';
import '../terminal/shared_terminal.dart';

part '../data/di/dependency_injection.dart';

class InitAurora with GlobalMixin {

  Future initDI() async {
   await DependencyInjection.initDI();
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

      Bloc.observer = ArBlocObserver();

    }
  }

  Future initParser(List<String> args) async{
    await ArArgsParser().initParser(args);
  }

}