abstract class UninstallEvent{}

class EventUInCheckDisableServices implements UninstallEvent{
  final bool? disableThreshold;
  final bool? disableFaustusModule;

  EventUInCheckDisableServices({this.disableThreshold, this.disableFaustusModule});
}

class EventUInSubmitDisableServices implements UninstallEvent{}