abstract class ControlPanelState{}

class ControlPanelInit extends ControlPanelState{}

class CPBrightnessPanel extends ControlPanelState{
  int brightness;
  CPBrightnessPanel({required this.brightness});
}

class CPModePanel extends ControlPanelState{
  int mode;
  CPModePanel({required this.mode});
}

class CPSpeedPanel extends ControlPanelState{
  int speed;
  CPSpeedPanel({required this.speed});
}