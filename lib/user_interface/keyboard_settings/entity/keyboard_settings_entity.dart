import 'package:aurora/shared/data/io/local/io_manager/io_manager.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_mainline_repo_impl.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:aurora/utility/global_mixin.dart';

import '../../../shared/utility/init_aurora.dart';
import '../domain/repositories/keyboard_settings_repo_impl.dart';

class KeyboardSettingsEntity with GlobalMixin{
  static KeyboardSettingsRepo getRepo(){
    final ioManager=sl<IOManager>();
    if(KeyboardSettingsEntity().isMainLine()){
      return KeyboardSettingsMainlineImpl(ioManager);
    }else{
      return KeyboardSettingsFaustusRepoImpl(ioManager);
    }
  }
}