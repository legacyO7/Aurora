
enum DBoiStates {init, terminal, completed}

class DBoi{

  final DBoiStates state;
  final bool disableThreshold;
  final bool disableFaustusModule;
  final bool uninstallAurora;

  const DBoi._({
    this.state=DBoiStates.init,
    this.disableThreshold=false,
    this.disableFaustusModule=false,
    this.uninstallAurora=false
  });

  const DBoi.init():this._();

  const DBoi.completed():this._(state: DBoiStates.completed);

  DBoi setState({
    bool? disableThreshold,
    bool? disableFaustusModule,
    bool? uninstallAurora,
    DBoiStates? state
  })=>DBoi._(
      disableThreshold: disableThreshold??this.disableThreshold,
      disableFaustusModule: disableFaustusModule??this.disableFaustusModule,
      uninstallAurora:uninstallAurora??this.uninstallAurora,
      state: state??this.state
    );


}