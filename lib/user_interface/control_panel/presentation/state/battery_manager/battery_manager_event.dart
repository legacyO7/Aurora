abstract class BatteryManagerEvent{}

class BatteryManagerEventInit implements BatteryManagerEvent{}

class BatteryManagerEventOnSlide implements BatteryManagerEvent{
  int value;
  BatteryManagerEventOnSlide({this.value=0});
}

class BatteryManagerEventOnSlideEnd implements BatteryManagerEvent{
  int value;
  BatteryManagerEventOnSlideEnd({this.value=0});
}
