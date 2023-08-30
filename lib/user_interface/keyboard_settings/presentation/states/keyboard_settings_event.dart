import 'dart:ui';

import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';

abstract class KeyboardSettingsEvent{}

class KeyboardSettingsEventInit extends KeyboardSettingsEvent{
  KeyboardSettingsEventInit();
}

class KeyboardSettingsEventReload extends KeyboardSettingsEvent{
  ArProfileModel arProfileModel;
  KeyboardSettingsEventReload(this.arProfileModel);
}

class KeyboardSettingsEventSetColor extends KeyboardSettingsEvent{
  final Color? color;
  KeyboardSettingsEventSetColor({this.color});
}

class KeyboardSettingsEventSetBrightness extends KeyboardSettingsEvent{
  final int brightness;
  KeyboardSettingsEventSetBrightness({this.brightness=0});
}

class KeyboardSettingsEventSetMode extends KeyboardSettingsEvent{
  final int mode;
  KeyboardSettingsEventSetMode({this.mode=0});
}

class KeyboardSettingsEventSetSpeed extends KeyboardSettingsEvent{
  final int speed;
  KeyboardSettingsEventSetSpeed({this.speed=0});
}

class KeyboardSettingsEventSetState extends KeyboardSettingsEvent{
  final bool? boot;
  final bool? awake;
  final bool? sleep;
  KeyboardSettingsEventSetState({this.boot, this.awake, this.sleep});
}