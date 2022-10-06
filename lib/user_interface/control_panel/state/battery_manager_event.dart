abstract class BatteryManagerEvent{}

class EventBMInit implements BatteryManagerEvent{}

class EventBMOnSlide implements BatteryManagerEvent{
  int value;
  EventBMOnSlide({this.value=0});
}

class EventBMOnSlideEnd implements BatteryManagerEvent{
  int value;
  EventBMOnSlideEnd({this.value=0});
}
