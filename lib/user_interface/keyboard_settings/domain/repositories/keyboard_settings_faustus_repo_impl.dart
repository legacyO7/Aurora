import 'dart:ui';

import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/constants.dart';

import 'keyboard_settings_repo.dart';

class KeyboardSettingsFaustusRepoImpl extends KeyboardSettingsRepo {

  KeyboardSettingsFaustusRepoImpl(this._ioManager, this._serviceManager);

  final IOManager _ioManager;
  final ServiceManager _serviceManager;

  @override
  List<int> get keys=>[0,1,2,3];

  @override
  Future setModeParams({required ArMode arMode}) async{
    arMode.color??=Color(arMode.colorRad!);

      await setSpeed(arMode: arMode);
      await setColor(arMode: arMode);

  }
  
  @override
  Future setMode({required ArMode arMode}) async{

      await _ioManager.writeToFile(
          filePath: Constants.kFaustusModuleModePath,
          content: "${keys[arMode.mode!]}"
      );
      await saveFaustusSettings();

      super.setMode(arMode: arMode);
  }

  @override
  Future setColor({required ArMode arMode}) async {

      Color color=arMode.color!;
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleRedPath, content: (color.r * 255).round().toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleGreenPath, content: (color.g * 255).round().toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleBluePath, content: (color.b * 255).round().toRadixString(16));

      ArColors.accentColor = color;
      await setMode(arMode: arMode);

  }

  @override
  Future setSpeed({required ArMode arMode}) async{
     await _ioManager.writeToFile(
        filePath: Constants.kFaustusModuleSpeedPath,
        content: "${arMode.speed}");
     super.setSpeed(arMode: arMode);
  }

  @override
  Future setBrightness(int brightness) async {
    await _ioManager.writeToFile(
        filePath: Constants.kFaustusModuleBrightnessPath,
        content:  brightness.toString()
    );
    super.setBrightness(brightness);
  }

  Future saveFaustusSettings() async{
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleFlagsPath, content: '2a');
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleSetPath, content: '1');
    await _serviceManager.updateService();
  }

  @override
  Future setMainlineStateParams({required ArState arState}) {
    throw UnimplementedError();
  }

}