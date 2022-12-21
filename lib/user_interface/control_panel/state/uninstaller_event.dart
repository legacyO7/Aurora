abstract class UninstallEvent{}

class UninstallEventCheckDisableServices extends UninstallEvent{
  final bool? disableThreshold;
  final bool? disableFaustusModule;

  UninstallEventCheckDisableServices({this.disableThreshold, this.disableFaustusModule});
}

class UninstallEventSubmitDisableServices extends UninstallEvent{}
class UninstallEventDispose extends UninstallEvent{}