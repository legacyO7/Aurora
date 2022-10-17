abstract class SetupEvent {}

class EventSWInit implements SetupEvent {}

class SetupEventConfigure implements SetupEvent {
  final bool allow;
  SetupEventConfigure({required this.allow});
}

class SetupEventIgnoreUpdate implements SetupEvent {}

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
