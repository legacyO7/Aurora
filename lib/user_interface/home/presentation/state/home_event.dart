abstract class HomeEvent{}

class EventHRequestAccess extends HomeEvent{}
class EventHLaunchUrl extends HomeEvent{
  String? url;
  EventHLaunchUrl({this.url});
}