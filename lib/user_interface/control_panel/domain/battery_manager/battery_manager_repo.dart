abstract class BatteryManagerRepo{
  Future<int> getBatteryCharge();
  Future setBatteryChargeLimit({required int limit});
}