import 'dart:ui';

import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';

import 'keyboard_settings_repo.dart';

class KeyboardSettingsRepoImpl extends KeyboardSettingsRepo with GlobalMixin{

  KeyboardSettingsRepoImpl(this._ioManager, this._isarDelegate);

  final IOManager _ioManager;
  final IsarDelegate _isarDelegate;

  final List<int> faustusKeys=[0,1,2,3];
  final List<int> mainLineKeys=[0,1,2,9];

  @override
  Future setMainlineStateParams({required ArState arState}) async{
    await _ioManager.writeToFile(filePath: Constants.kMainlineModuleStatePath,content: "1 ${ArState.arStateToIntString(arState)} 0");
    await _isarDelegate.setArState(arState:arState);
  }

  @override
  Future setMainlineModeParams({required ArMode arMode}) async{
    arMode.color??=Color(arMode.colorRad!);
    if(super.isMainLine()) {
      await _ioManager.writeToFile(
        filePath: Constants.kMainlineModuleModePath,
        content: "1 ${mainLineKeys[arMode.mode!]} ${arMode.color!.red} ${arMode.color!.green} ${arMode.color!.blue} ${arMode.speed}");

      await _isarDelegate.setArMode(arMode: arMode);
    }else{
      await setMode(arMode: arMode);
      await setSpeed(arMode: arMode);
      await setColor(arMode: arMode);
    }
  }
  
  @override
  Future setMode({required ArMode arMode}) async{
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      await _ioManager.writeToFile(
          filePath: Constants.kFaustusModuleModePath,
          content: "${faustusKeys[arMode.mode!]}"
      );
      await saveFaustusSettings();
    }
    await _isarDelegate.setArMode(arMode: arMode);
  }

  @override
  Future setColor({required ArMode arMode}) async {
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      Color color=arMode.color!;
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleRedPath, content: color.red.toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleGreenPath, content: color.green.toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleBluePath, content: color.blue.toRadixString(16));

      ArColors.accentColor = color;
      await setMode(arMode: arMode);
    }
  }

  @override
  Future setSpeed({required ArMode arMode}) async{
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      await _ioManager.writeToFile(
          filePath: Constants.kFaustusModuleSpeedPath,
          content: "${arMode.speed}");
    }
    await _isarDelegate.setArMode(arMode: arMode);
  }

  @override
  Future setBrightness(int brightness) async {
    await _ioManager.writeToFile(
        filePath: super.isMainLine()?Constants.kMainlineBrightnessPath: Constants.kFaustusModuleBrightnessPath,
        content:  brightness.toString()
    );
    _isarDelegate.setBrightness(brightness);
  }

  Future saveFaustusSettings() async{
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleFlagsPath, content: '2a');
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleSetPath, content: '1');
  }

}