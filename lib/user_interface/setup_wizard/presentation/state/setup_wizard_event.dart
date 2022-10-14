abstract class SetupWizardEvent{}

class EventSWInit implements SetupWizardEvent{}
class EventSWAllowConfigure implements SetupWizardEvent{
  final bool allow;
  EventSWAllowConfigure({required this.allow});
}
class EventSWOnCancel implements SetupWizardEvent{
  final int stepValue;

  EventSWOnCancel({required this.stepValue});
}
class EventSWOnInstall implements SetupWizardEvent{
  final int stepValue;
  EventSWOnInstall({required this.stepValue});
}

class EventSWValidateRepo implements SetupWizardEvent{
  final String url;
  EventSWValidateRepo({required this.url});
}