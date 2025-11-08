part of 'preferences_bloc.dart';

abstract class PreferencesEvent{}

 class PreferencesInitEvent extends PreferencesEvent {}

class PreferencesSetEvent extends PreferencesEvent {

   bool? isBacklightControllerEnabled;
   bool? isBacklightControllerServiceEnabled;
   bool? isBatteryManagerEnabled;

   PreferencesSetEvent({
     this.isBacklightControllerEnabled,
     this.isBatteryManagerEnabled,
     this.isBacklightControllerServiceEnabled});
}

class PreferencesSaveEvent extends PreferencesEvent{}
