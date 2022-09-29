import 'package:equatable/equatable.dart';

class ControlPanelStateInit extends Equatable{
  final bool disableThreshold;
  final bool disableFaustusModule;

  const ControlPanelStateInit({this.disableThreshold=false,  this.disableFaustusModule=false});

  @override
  List<Object?> get props => [disableFaustusModule,disableThreshold];
}

class ControlPanelTerminalState extends Equatable{
  const ControlPanelTerminalState();

  @override
  List<Object?> get props => [];
}