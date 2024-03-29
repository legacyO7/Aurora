abstract class SetupEvent {}

class EventSWInit implements SetupEvent {}

class SetupEventConfigure implements SetupEvent {
  final bool allow;
  SetupEventConfigure({required this.allow});
}

class SetupEventBatteryManagerMode implements SetupEvent {
  SetupEventBatteryManagerMode();
}

class SetupEventOnUpdate implements SetupEvent {
  final bool ignoreUpdate;
  SetupEventOnUpdate({required this.ignoreUpdate});
}

class SetupEventOnCancel implements SetupEvent {
  final int stepValue;
  SetupEventOnCancel({required this.stepValue});
}

class SetupEventOnInstall implements SetupEvent {
  final int stepValue;
  SetupEventOnInstall({required this.stepValue});
}

class SetupEventValidateRepo implements SetupEvent {
  final String url;
  SetupEventValidateRepo({required this.url});
}

class SetupEventCompatibleKernel implements SetupEvent{
  bool removeFaustus;
  SetupEventCompatibleKernel({this.removeFaustus = false});
}

class SetupEventClearCache implements SetupEvent{
  SetupEventClearCache();
}
class SetupEventRebirth implements SetupEvent{
  SetupEventRebirth();
}

class SetupEventLaunch extends SetupEvent{
  String? url;
  SetupEventLaunch({this.url});
}


