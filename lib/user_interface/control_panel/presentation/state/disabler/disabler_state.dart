import 'package:equatable/equatable.dart';

abstract class DisableState extends Equatable{

}

class DisableInitState extends DisableState {
  final bool disableThreshold;
  final bool disableFaustusModule;
  final bool uninstallAurora;


  DisableInitState({
    this.disableThreshold = false,
    this.disableFaustusModule = false,
    this.uninstallAurora=false
  });

  DisableInitState copyState({
    bool? disableThreshold,
    bool? disableFaustusModule,
    bool? uninstallAurora
  }) {
    return DisableInitState(
        disableThreshold: disableThreshold ?? this.disableThreshold,
        disableFaustusModule: disableFaustusModule ?? this.disableFaustusModule,
        uninstallAurora: uninstallAurora??this.uninstallAurora
    );
  }

  @override
  List<Object?> get props => [disableFaustusModule, disableThreshold, uninstallAurora];

}

class DisableTerminalState extends DisableState {
  DisableTerminalState();

  @override
  List<Object?> get props => [];
  
}

class DisableProcessCompletedState extends DisableState{
  @override
  List<Object?> get props => [];
}