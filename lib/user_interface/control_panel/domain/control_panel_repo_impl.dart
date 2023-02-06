import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';

import 'control_panel_repo.dart';

class ControlPanelRepoImpl extends ControlPanelRepo{


  ControlPanelRepoImpl(this._terminalSource, this._prefRepo);

  final TerminalSource _terminalSource;
  final PrefRepo _prefRepo;

  final _globalConfig=Constants.globalConfig;

  @override
  Future saveState({required int boot, required int awake, required int sleep}) async{
    await _terminalSource.execute("${_globalConfig.kExecMainlinePath} state 1 $boot $awake $sleep 0");
    await _prefRepo.setState(awake: awake==1, boot: boot==1,sleep: sleep==1);
  }

}