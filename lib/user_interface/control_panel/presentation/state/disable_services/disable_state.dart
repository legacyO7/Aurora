
part of 'disable_bloc.dart';

enum DisableStateStates {init, terminal, completed}

class DisableState{

  final DisableStateStates state;
  final bool disableThreshold;
  final bool disableFaustusModule;
  final bool uninstallAurora;

  const DisableState._({
    this.state=DisableStateStates.init,
    this.disableThreshold=false,
    this.disableFaustusModule=false,
    this.uninstallAurora=false
  });

  const DisableState.init():this._();

  const DisableState.completed():this._(state: DisableStateStates.completed);


  DisableState setState({
    bool? disableThreshold,
    bool? disableFaustusModule,
    bool? uninstallAurora,
    DisableStateStates? state
  })=>DisableState._(
      disableThreshold: disableThreshold??this.disableThreshold,
      disableFaustusModule: disableFaustusModule??this.disableFaustusModule,
      uninstallAurora:uninstallAurora??this.uninstallAurora,
      state: state??this.state
    );

}