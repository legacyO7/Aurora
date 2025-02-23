import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/disable_settings/domain/repository/disable_settings_repo.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/global_mixin.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends TerminalBaseBloc<PreferencesEvent, PreferencesState> with GlobalMixin {

  final IsarDelegate _isarDelegate;
  final DisableSettingsRepo _disableSettingsRepo;

  PreferencesBloc(this._isarDelegate, this._disableSettingsRepo) : super(PreferencesState.init()) {
    on<PreferencesInitEvent>((_, emit) => _initPreferences(emit));
    on<PreferencesSetEvent>((event, emit) => _setPreferences(emit, event: event));
    on<PreferencesSaveEvent>((event, emit) => _savePreferences(emit));
  }

  _initPreferences(emit) {
    emit(state.setState(isLoading: false));
    _setPreferences(emit, event: PreferencesSetEvent(isBatteryManagerEnabled: _isarDelegate.getBatteryManagerAvailability(),
        isBacklightControllerEnabled: _isarDelegate.getBacklightControllerAvailability()));
  }

  _setPreferences(emit, {required PreferencesSetEvent event}) {

    emit(state.setState(
        isBatteryManagerEnabled: event.isBatteryManagerEnabled, isBacklightControllerEnabled: event.isBacklightControllerEnabled));

    if (!(state.isBacklightControllerEnabled) && !(state.isBatteryManagerEnabled)) {
      if(event.isBacklightControllerEnabled==null||event.isBatteryManagerEnabled==null) {
        emit(state.setState(isBatteryManagerEnabled: event.isBatteryManagerEnabled ?? true,
          isBacklightControllerEnabled: event.isBacklightControllerEnabled ?? true));
      }else{
        emit(state.setState(isBatteryManagerEnabled: true, isBacklightControllerEnabled: true));
      }
    }
  }

  _savePreferences(emit) async {
    emit(state.setState(isLoading: true));
      if(await _disableSettingsRepo.disableServices(
          disable: !state.isBatteryManagerEnabled ? DisableEnum.threshold : !state.isBacklightControllerEnabled ? super.isMainLine()
              ? DisableEnum.none
              : DisableEnum.faustus
              : DisableEnum.none)) {
      await _isarDelegate.saveBatteryAvailability(state.isBatteryManagerEnabled);
      await _isarDelegate.saveBacklightAvailability(state.isBacklightControllerEnabled);
      super.restartApp();
    }else{
        emit(state.setState(isLoading: false));
      }
  }

}
