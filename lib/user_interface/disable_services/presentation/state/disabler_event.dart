sealed class DisableEvent{}

class DisableEventInit extends DisableEvent{}

class DisableEventCheckDisableServices extends DisableEvent{
  final bool? disableThreshold;
  final bool? disableFaustusModule;
  final bool? uninstallAurora;

  DisableEventCheckDisableServices({this.disableThreshold, this.disableFaustusModule, this.uninstallAurora});

}

class DisableEventSubmitDisableServices extends DisableEvent{}
