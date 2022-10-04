import 'package:aurora/data/di/di.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';

mixin HomeMixin on HomeRepo{


  @override
  Future<bool> isSecureBootEnabled() async{
    return (await sl<TerminalRepo>().getOutput(command: "mokutil --sb-state")).toString().contains("enabled");
  }
  
}