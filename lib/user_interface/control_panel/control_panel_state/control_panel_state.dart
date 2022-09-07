abstract class ControlPanelState{}

class ControlPanelInit extends ControlPanelState{

}

class CPBrightnessPanel extends ControlPanelState{
  int brightness;
  CPBrightnessPanel({required this.brightness});
}