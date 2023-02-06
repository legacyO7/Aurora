abstract class ControlPanelRepo{
  Future saveState({required int boot, required int awake, required int sleep});
}