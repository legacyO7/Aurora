import 'package:equatable/equatable.dart';

abstract class UninstallState extends Equatable{

}

class UninstallInitState extends UninstallState {
  final bool disableThreshold;
  final bool disableFaustusModule;

  UninstallInitState({
    this.disableThreshold = false,
    this.disableFaustusModule = false});

  UninstallInitState copyState({
    bool? disableThreshold,
    bool? disableFaustusModule
  }) {
    return UninstallInitState(
        disableThreshold: disableThreshold ?? this.disableThreshold,
        disableFaustusModule: disableFaustusModule ?? this.disableFaustusModule
    );
  }

  @override
  List<Object?> get props => [disableFaustusModule, disableThreshold];

}

class UninstallTerminalState extends UninstallState {
  UninstallTerminalState();

  @override
  List<Object?> get props => [];
  
}

class UninstallProcessCompletedState extends UninstallState{
  @override
  List<Object?> get props => [];
}