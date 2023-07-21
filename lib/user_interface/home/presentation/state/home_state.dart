
enum HomeStates {init, accessGranted, cannotElevate}

class HomeState{

  final HomeStates state;

  final bool loggingEnabled;
  final List<String> deniedList;
  final bool hasAccess;
  final bool runAsRoot;

  const HomeState._({
    this.state=HomeStates.init,
    this.loggingEnabled=false,
    this.deniedList=const[],
    this.hasAccess=false,
    this.runAsRoot=false
  });

  const HomeState.init(): this._();

  const HomeState.accessGranted({
    bool hasAccess=false,
    bool runAsRoot=false
  }):this._(hasAccess: hasAccess,runAsRoot: runAsRoot,state: HomeStates.accessGranted);

  HomeState setState({
    bool? loggingEnabled,
    List<String>? deniedList,
    HomeStates? state
  })=>HomeState._(
    state: state??this.state,
    loggingEnabled: loggingEnabled??this.loggingEnabled,
    deniedList: deniedList??this.deniedList,
    runAsRoot: runAsRoot,
    hasAccess: hasAccess
  );

}