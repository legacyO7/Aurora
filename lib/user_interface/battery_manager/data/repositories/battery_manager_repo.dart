abstract class BatteryManagerRepo{
  Future initBatteryManager();
  Future<int> getBatteryCharge();
  Future setBatteryChargeLimit({required int limit});
}