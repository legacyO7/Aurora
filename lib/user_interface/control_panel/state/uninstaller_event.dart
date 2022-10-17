abstract class UninstallEvent{}

class UninstallEventCheckDisableServices implements UninstallEvent{
  final bool? disableThreshold;
  final bool? disableFaustusModule;

  UninstallEventCheckDisableServices({this.disableThreshold, this.disableFaustusModule});
}

class UninstallEventSubmitDisableServices implements UninstallEvent{}