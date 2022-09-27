abstract class ControlPanelState{}

class ControlPanelStateInit extends ControlPanelState{
  bool disableThreshold=false;
  bool disableFaustusModule=false;

  ControlPanelStateInit({required this.disableThreshold, required this.disableFaustusModule});
}

class ControlPanelTerminalState extends ControlPanelState{
  ControlPanelTerminalState();
}