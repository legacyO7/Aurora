


abstract class HomeState{}

class HomeStateInit extends HomeState{}

class AccessGranted extends HomeState{
  bool hasAccess;
  AccessGranted({required this.hasAccess});
}