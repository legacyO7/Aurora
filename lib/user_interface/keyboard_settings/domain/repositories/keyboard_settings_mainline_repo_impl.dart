import 'dart:ui';

import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:aurora/utility/constants.dart';


class KeyboardSettingsMainlineRepoImpl extends KeyboardSettingsRepo{

  KeyboardSettingsMainlineRepoImpl(this._ioManager);

  final IOManager _ioManager;
  final List<int> mainLineKeys=[0,1,2,9];

  @override
  Future setBrightness(int brightness) async {
    await _ioManager.writeToFile(
        filePath: Constants.kMainlineBrightnessPath,
        content:  brightness.toString()
    );
    super.setBrightness(brightness);
  }

  @override
  Future setColor({required ArMode arMode}) async {
    await setModeParams(arMode: arMode);
  }

  @override
  Future setMode({required ArMode arMode}) async{
    await setModeParams(arMode: arMode);
  }

  @override
  Future setSpeed({required ArMode arMode}) async {
    await setModeParams(arMode: arMode);
  }

  @override
  Future setModeParams({required ArMode arMode}) async{
    arMode.color??=Color(arMode.colorRad!);

    await _ioManager.writeToFile(
        filePath: Constants.kMainlineModuleModePath,
        content: "1 ${mainLineKeys[arMode.mode!]} ${arMode.color!.red} ${arMode.color!.green} ${arMode.color!.blue} ${arMode.speed}");
    super.setModeParams(arMode: arMode);
  }

  @override
  Future setMainlineStateParams({required ArState arState}) async{
    await _ioManager.writeToFile(filePath: Constants.kMainlineModuleStatePath,content: "1 ${ArState.arStateToIntString(arState)} 0");
    super.setMainlineStateParams(arState: arState);
  }


  
}