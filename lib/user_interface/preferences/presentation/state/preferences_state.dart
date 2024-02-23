part of 'preferences_bloc.dart';

class PreferencesState {

  bool isBacklightControllerEnabled;
  bool isBatteryManagerEnabled;

  PreferencesState._({this.isBacklightControllerEnabled=false, this.isBatteryManagerEnabled=false});

  PreferencesState.init():this._();

  PreferencesState setState({
    bool? isBacklightControllerEnabled,
    bool? isBatteryManagerEnabled
  }){
    return PreferencesState._(
      isBacklightControllerEnabled: isBacklightControllerEnabled??this.isBacklightControllerEnabled,
      isBatteryManagerEnabled: isBatteryManagerEnabled??this.isBatteryManagerEnabled
    );
  }




}
