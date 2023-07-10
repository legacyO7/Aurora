
abstract class HomeState{}

class HomeStateInit extends HomeState{
  bool loggingEnabled;
  HomeStateInit({this.loggingEnabled=false});
}

class AccessGranted extends HomeState{
  bool hasAccess;
  bool runAsRoot;
  bool loggingEnabled;
  AccessGranted({this.hasAccess=false,this.runAsRoot=false, this.loggingEnabled=false});
}

class HomeStateCannotElevate extends HomeState{}

class HomeStateLoggingEnabled extends HomeState{}