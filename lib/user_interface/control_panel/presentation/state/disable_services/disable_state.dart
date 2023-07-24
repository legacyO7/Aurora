
part of 'disable_bloc.dart';

enum DisableStateStates {init}

class DisableSettingsState extends Equatable{

  final DisableStateStates state;
  final bool disableThreshold;
  final bool disableFaustusModule;
  final bool uninstallAurora;

  const DisableSettingsState._({
    this.state=DisableStateStates.init,
    this.disableThreshold=false,
    this.disableFaustusModule=false,
    this.uninstallAurora=false
  });

  const DisableSettingsState.init():this._();


  DisableSettingsState setState({
    bool? disableThreshold,
    bool? disableFaustusModule,
    bool? uninstallAurora,
    DisableStateStates? state
  })=>DisableSettingsState._(
      disableThreshold: disableThreshold??this.disableThreshold,
      disableFaustusModule: disableFaustusModule??this.disableFaustusModule,
      uninstallAurora:uninstallAurora??this.uninstallAurora,
      state: state??this.state
    );

  @override
  List<Object?> get props => [state, disableThreshold, disableFaustusModule, uninstallAurora];

}