import 'package:aurora/utility/ar_widgets/ar_enums.dart';

abstract class HomeEvent{}

class HomeEventRequestAccess extends HomeEvent{}

class HomeEventRunAsRoot extends HomeEvent{}

class HomeEventInit extends HomeEvent{}

class HomeEventEnableLogging extends HomeEvent{}

class HomeEventEnforcement extends HomeEvent{
  Enforcement enforcement;
  HomeEventEnforcement(this.enforcement);
}

class HomeEventLaunch extends HomeEvent{
  String? url;
  HomeEventLaunch({this.url});
}
class HomeEventDispose extends HomeEvent{}
