

abstract class BatteryManagerState{}

class BatteryManagerInit extends BatteryManagerState{
  int batteryLevel;
  BatteryManagerInit({required this.batteryLevel});
}