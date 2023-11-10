

import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';

abstract class KeyboardSettingsRepo{

  final IsarDelegate _isarDelegate=sl<IsarDelegate>();

  Future setMode({required ArMode arMode}) async =>
      await _setArMode(arMode);

  Future setColor({required ArMode arMode});

  Future setSpeed({required ArMode arMode}) async =>
      await _setArMode(arMode);

  Future setModeParams({required ArMode arMode}) async =>
    await _setArMode(arMode);

  Future setBrightness(int brightness)async=>
    await _isarDelegate.setBrightness(brightness);

  Future setMainlineStateParams({required ArState arState})async=>
      await _isarDelegate.setArState(arState:arState);

  Future _setArMode(ArMode arMode) async=>
      await _isarDelegate.setArMode(arMode: arMode);
}