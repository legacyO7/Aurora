import 'package:equatable/equatable.dart';

abstract class DisableState extends Equatable{

}

class DisableInitState extends DisableState {
  final bool disableThreshold;
  final bool disableFaustusModule;


  DisableInitState({
    this.disableThreshold = false,
    this.disableFaustusModule = false
  });

  DisableInitState copyState({
    bool? disableThreshold,
    bool? disableFaustusModule
  }) {
    return DisableInitState(
        disableThreshold: disableThreshold ?? this.disableThreshold,
        disableFaustusModule: disableFaustusModule ?? this.disableFaustusModule
    );
  }

  @override
  List<Object?> get props => [disableFaustusModule, disableThreshold];

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