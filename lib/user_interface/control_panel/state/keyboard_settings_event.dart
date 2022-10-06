import 'dart:ui';

abstract class KeyboardSettingsEvent{}

class EventKSInit extends KeyboardSettingsEvent{
  EventKSInit();
}

class EventKSColor extends KeyboardSettingsEvent{
  final Color? color;
  EventKSColor({this.color});
}

class EventKSBrightness extends KeyboardSettingsEvent{
  final int brightness;
  EventKSBrightness({this.brightness=0});
}

class EventKSMode extends KeyboardSettingsEvent{
  final int mode;
  EventKSMode({this.mode=0});
}

class EventKSSpeed extends KeyboardSettingsEvent{
  final int speed;
  EventKSSpeed({this.speed=0});
}