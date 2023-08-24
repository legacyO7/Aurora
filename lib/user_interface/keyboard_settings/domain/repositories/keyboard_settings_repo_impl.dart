import 'dart:ui';


import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';

import 'keyboard_settings_repo.dart';

class KeyboardSettingsRepoImpl extends KeyboardSettingsRepo with GlobalMixin{

  KeyboardSettingsRepoImpl(this._homeRepo, this._isarDelegate);

  final HomeRepo _homeRepo;
  final IsarDelegate _isarDelegate;

  final List<int> faustusKeys=[0,1,2,3];
  final List<int> mainLineKeys=[0,1,2,9];

  @override
  Future setMainlineStateParams({required int boot, required int awake, required int sleep}) async{
    await _homeRepo.writeToFile(path: Constants.kMainlineModuleStatePath,content: "1 $boot $awake $sleep 0");
    await _isarDelegate.setArState(arState:ArState(awake: awake==1,sleep: sleep==1,boot: boot==1));
  }

  @override
  Future setMainlineModeParams({required ArMode arMode}) async{
    arMode.color??=Color(arMode.colorRad!);
    if(super.isMainLine()) {
      await _homeRepo.writeToFile(
        path: Constants.kMainlineModuleModePath,
        content: "1 ${mainLineKeys[arMode.mode!]} ${arMode.color!.red} ${arMode.color!.green} ${arMode.color!.blue} ${arMode.speed}");
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
      await _homeRepo.writeToFile(
          path: Constants.kFaustusModuleModePath,
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
      await _homeRepo.writeToFile(path: Constants.kFaustusModuleRedPath, content: color.red.toRadixString(16));
      await _homeRepo.writeToFile(path: Constants.kFaustusModuleGreenPath, content: color.green.toRadixString(16));
      await _homeRepo.writeToFile(path: Constants.kFaustusModuleBluePath, content: color.blue.toRadixString(16));

      ArColors.accentColor = color;
      await setMode(arMode: ArMode(mode: 0));

    }
    await _isarDelegate.setArMode(arMode: arMode);
  }

  @override
  Future setSpeed({required ArMode arMode}) async{
    if(super.isMainLine()){
      await setMainlineModeParams(arMode: arMode);
    }else {
      await _homeRepo.writeToFile(
          path: Constants.kFaustusModuleSpeedPath,
          content: "${arMode.speed}");
    }
    await _isarDelegate.setArMode(arMode: arMode);
  }

  @override
  Future setBrightness(int brightness) async {
    await _homeRepo.writeToFile(
        path: super.isMainLine()?Constants.kMainlineBrightnessPath: Constants.kFaustusModuleBrightnessPath,
        content:  brightness.toString()
    );
    _isarDelegate.setBrightness(brightness);
  }

  Future saveFaustusSettings() async{
    await _homeRepo.writeToFile(path: Constants.kFaustusModuleFlagsPath, content: '2a');
    await _homeRepo.writeToFile(path: Constants.kFaustusModuleSetPath, content: '1');
  }

}