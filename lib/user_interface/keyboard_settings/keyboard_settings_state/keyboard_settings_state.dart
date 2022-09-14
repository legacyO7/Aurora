import 'dart:ui';

abstract class KeyboardSettingsState{}

class KeyboardSettingsInit extends KeyboardSettingsState{}

class KeyboardSettingsBrightnessPanel extends KeyboardSettingsState{
  int brightness;
  KeyboardSettingsBrightnessPanel({required this.brightness});
}

class KeyboardSettingsModePanel extends KeyboardSettingsState{
  int mode;
  KeyboardSettingsModePanel({required this.mode});
}

class KeyboardSettingsSpeedPanel extends KeyboardSettingsState{
  int speed;
  KeyboardSettingsSpeedPanel({required this.speed});
}

class KeyboardSettingsColorPanel extends KeyboardSettingsState{
  Color color;
  KeyboardSettingsColorPanel({required this.color});
}