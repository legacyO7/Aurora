import 'dart:ui';

import 'package:aurora/data/model/ar_mode_model.dart';
import 'package:aurora/data/model/ar_state_model.dart';
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';

import 'control_panel_repo.dart';

class ControlPanelRepoImpl extends ControlPanelRepo with GlobalMixin{

  ControlPanelRepoImpl(this._terminalSource, this._prefRepo);

  final TerminalSource _terminalSource;
  final PrefRepo _prefRepo;

  final _globalConfig=Constants.globalConfig;

  @override
  Future setMainlineStateParams({required int boot, required int awake, required int sleep}) async{
    await _terminalSource.execute("${_globalConfig.kExecMainlinePath} state 1 $boot $awake $sleep 0");
    await _prefRepo.setArState(arState:ArState(awake: awake==1,sleep: sleep==1,boot: boot==1));
  }

  @override
  Future setMainlineModeParams({required ArMode arMode}) async{
    await _terminalSource.execute("${_globalConfig.kExecMainlinePath} mode 1 ${arMode.mode} ${arMode.color!.red} ${arMode.color!.green} ${arMode.color!.blue} ${arMode.speed}");
  }
  
  @override
  Future setMode({required ArMode arMode}) async{
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      await _terminalSource.execute("${_globalConfig.kExecFaustusPath} mode ${arMode.mode} ");
    }
    await _prefRepo.setArMode(arMode: arMode);
  }

  @override
  Future setColor({required ArMode arMode}) async {
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      Color color=arMode.color!;
      await _terminalSource.execute(
          "${_globalConfig.kExecFaustusPath} color ${color.red
              .toRadixString(16)} ${color.green.toRadixString(16)} ${color
              .blue.toRadixString(16)} 0");
      ArColors.accentColor = color;
      if(arMode.mode!=null){
        await setMode(arMode: arMode);
      }
    }
    await _prefRepo.setArMode(arMode: arMode);
  }

  @override
  Future setSpeed({required ArMode arMode}) async{
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      await _terminalSource.execute("${_globalConfig.kExecFaustusPath} speed ${arMode.speed} ");
    }
    await _prefRepo.setArMode(arMode: arMode);
  }

  @override
  Future setBrightness(int brightness) async {
    await _terminalSource.execute("${super.isMainLine()?_globalConfig.kExecMainlinePath: _globalConfig.kExecFaustusPath} brightness $brightness ");
    _prefRepo.setBrightness(brightness);
  }

}