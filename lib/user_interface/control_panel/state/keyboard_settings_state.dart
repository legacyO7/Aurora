import 'dart:ui';

abstract class KeyboardSettingsState{}

class KeyboardSettingsInitState extends KeyboardSettingsState{}
class KeyboardSettingsLoadedState extends KeyboardSettingsState{
  int brightness;
  int mode;
  int speed;
  Color color;
  KeyboardSettingsLoadedState({required this.brightness, required this.mode, required this.speed, required this.color});
}
