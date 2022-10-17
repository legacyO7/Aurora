abstract class HomeEvent{}

class HomeEventRequestAccess extends HomeEvent{}
class HomeEventLaunch extends HomeEvent{
  String? url;
  HomeEventLaunch({this.url});
}