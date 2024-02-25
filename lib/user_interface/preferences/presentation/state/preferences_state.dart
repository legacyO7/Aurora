part of 'preferences_bloc.dart';

class PreferencesState {

  bool isBacklightControllerEnabled;
  bool isBatteryManagerEnabled;
  bool isLoading;

  PreferencesState._({this.isBacklightControllerEnabled=false, this.isBatteryManagerEnabled=false, this.isLoading=false});

  PreferencesState.init():this._();

  PreferencesState setState({
    bool? isBacklightControllerEnabled,
    bool? isBatteryManagerEnabled,
    bool? isLoading
  }){
    return PreferencesState._(
      isBacklightControllerEnabled: isBacklightControllerEnabled??this.isBacklightControllerEnabled,
      isBatteryManagerEnabled: isBatteryManagerEnabled??this.isBatteryManagerEnabled,
      isLoading: isLoading??this.isLoading
    );
  }




}
