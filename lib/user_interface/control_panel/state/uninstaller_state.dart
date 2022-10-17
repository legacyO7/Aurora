import 'package:equatable/equatable.dart';

abstract class ControlPanelState extends Equatable{

}

class ControlPanelStateInit implements ControlPanelState {
  final bool disableThreshold;
  final bool disableFaustusModule;

  const ControlPanelStateInit({
    this.disableThreshold = false,
    this.disableFaustusModule = false});

  ControlPanelStateInit copyState({
    bool? disableThreshold,
    bool? disableFaustusModule
  }) {
    return ControlPanelStateInit(
        disableThreshold: disableThreshold ?? this.disableThreshold,
        disableFaustusModule: disableFaustusModule ?? this.disableFaustusModule
    );
  }

  @override
  List<Object?> get props => [disableFaustusModule, disableThreshold];

  @override
  bool? get stringify => throw UnimplementedError();

}

class ControlPanelTerminalState implements ControlPanelState {
  const ControlPanelTerminalState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => throw UnimplementedError();
}