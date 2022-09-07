
import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo_impl.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.I;

Future initDI() async{
  serviceLocator.allowReassignment=true;
  serviceLocator.registerLazySingleton(() => HomeCubit(serviceLocator()));
  serviceLocator.registerLazySingleton<TerminalRepo>(() => TerminalRepoImpl());
}