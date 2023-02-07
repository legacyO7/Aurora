abstract class DisableEvent{}

class DisableEventCheckDisableServices extends DisableEvent{
  final bool? disableThreshold;
  final bool? disableFaustusModule;

  DisableEventCheckDisableServices({this.disableThreshold, this.disableFaustusModule});
}

class DisableEventSubmitDisableServices extends DisableEvent{}
class DisableEventDispose extends DisableEvent{}