import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_mainline_repo_impl.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:aurora/utility/global_mixin.dart';

import '../../../shared/utility/init_aurora.dart';
import '../domain/repositories/keyboard_settings_repo_impl.dart';

class KeyboardSettingsEntity with GlobalMixin{
  static KeyboardSettingsRepo getRepo(){
    if(KeyboardSettingsEntity().isMainLine()){
      return sl<KeyboardSettingsMainlineRepoImpl>();
    }else{
      return sl<KeyboardSettingsFaustusRepoImpl>();
    }
  }
}