abstract class HomeEvent{}

class HomeEventRequestAccess extends HomeEvent{}

class HomeEventRunAsRoot extends HomeEvent{}

class HomeEventInit extends HomeEvent{}

class HomeEventLaunch extends HomeEvent{
  String? url;
  HomeEventLaunch({this.url});
}
class HomeEventDispose extends HomeEvent{}
