part of 'preferences_bloc.dart';

abstract class PreferencesEvent{}

 class PreferencesInitEvent extends PreferencesEvent {}

class PreferencesSetEvent extends PreferencesEvent {

   bool? isBacklightControllerEnabled;
   bool? isBatteryManagerEnabled;

   PreferencesSetEvent({this.isBacklightControllerEnabled, this.isBatteryManagerEnabled});
}

class PreferencesSaveEvent extends PreferencesEvent{}
