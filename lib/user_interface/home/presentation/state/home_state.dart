


abstract class HomeState{}

class HomeStateInit extends HomeState{}

class AccessGranted extends HomeState{
  bool hasAccess;
  bool runAsRoot;
  AccessGranted({this.hasAccess=false,this.runAsRoot=false});
}

class HomeStateCannotElevate extends HomeState{}