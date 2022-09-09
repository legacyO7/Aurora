import 'dart:ui';

abstract class PrefRepo{

  Future<String?> getVersion();
  Future<int> getBrightness();
  Future<Color> getColor();
  Future<int> getMode();
  Future<int> getSpeed();

  Future setVersion(String version);
  Future setBrightness(int brightness);
  Future setColor(String color);
  Future setMode(int mode);
  Future setSpeed(int speed);

}