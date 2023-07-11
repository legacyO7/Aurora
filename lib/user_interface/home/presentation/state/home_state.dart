
class H {
  HomeState homeState;

  H(this.homeState);
}

class HomeState{
  bool loggingEnabled;
  List<String> deniedList;

  HomeState({this.loggingEnabled=false, this.deniedList=const[]});

  HomeState setState({bool? loggingEnabled, List<String>? deniedList}){
    return HomeState(
      loggingEnabled: loggingEnabled??this.loggingEnabled,
      deniedList: deniedList??this.deniedList,
    );
  }

}

class HomeStateInit extends HomeState{
  HomeStateInit({super.loggingEnabled,super.deniedList});
}

class AccessGranted extends HomeState{
  bool hasAccess;
  bool runAsRoot;
  HomeState homeState;
  AccessGranted(this.homeState,{this.hasAccess=false,this.runAsRoot=false}):
        super(deniedList: homeState.deniedList,loggingEnabled: homeState.loggingEnabled);
}

class HomeStateCannotElevate extends HomeState{
  HomeState homeState;
  HomeStateCannotElevate(this.homeState):
        super(deniedList: homeState.deniedList,loggingEnabled: homeState.loggingEnabled);
}

class HomeStateLoggingEnabled extends HomeState{}

class HomeStateRebirth extends HomeState{}