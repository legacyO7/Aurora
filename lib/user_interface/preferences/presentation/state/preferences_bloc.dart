import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/disable_settings/domain/repository/disable_settings_repo.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends TerminalBaseBloc<PreferencesEvent, PreferencesState> with GlobalMixin {

  final IsarDelegate _isarDelegate;
  final DisableSettingsRepo _disableSettingsRepo;

  late bool _initialBatteryManagerEnabledValue, _initialBacklightControllerEnabledValue, _initialBacklightControllerServiceEnabledValue;

  PreferencesBloc(this._isarDelegate, this._disableSettingsRepo) : super(PreferencesState.init()) {
    on<PreferencesInitEvent>((_, emit) => _initPreferences(emit));
    on<PreferencesSetEvent>((event, emit) => _setPreferences(emit, event: event));
    on<PreferencesSaveEvent>((event, emit) => _savePreferences(emit));
  }

  void _initPreferences(Emitter emit) {
    emit(state.setState(isLoading: false));
    _initialBatteryManagerEnabledValue=_isarDelegate.getBatteryManagerAvailability();
    _initialBacklightControllerEnabledValue=_isarDelegate.getBacklightControllerAvailability();
    _initialBacklightControllerServiceEnabledValue=_isarDelegate.getBacklightControllerServiceAvailability();

    _setPreferences(emit, event: PreferencesSetEvent(
        isBatteryManagerEnabled: _isarDelegate.getBatteryManagerAvailability(),
        isBacklightControllerEnabled: _isarDelegate.getBacklightControllerAvailability(),
        isBacklightControllerServiceEnabled: _isarDelegate.getBacklightControllerServiceAvailability()
    ));
  }

  void _setPreferences(Emitter emit, {required PreferencesSetEvent event}) {

    emit(state.setState(
        isBatteryManagerEnabled: event.isBatteryManagerEnabled,
        isBacklightControllerEnabled: event.isBacklightControllerEnabled,
        isBacklightControllerServiceEnabled: event.isBacklightControllerServiceEnabled
    ));

    if (!(state.isBacklightControllerEnabled) && !(state.isBatteryManagerEnabled)) {
      if(event.isBacklightControllerEnabled==null||event.isBatteryManagerEnabled==null) {
        emit(state.setState(isBatteryManagerEnabled: event.isBatteryManagerEnabled ?? true,
          isBacklightControllerEnabled: event.isBacklightControllerEnabled ?? true));
      }else{
        emit(state.setState(isBatteryManagerEnabled: true, isBacklightControllerEnabled: true));
      }
    }
  }

  Future<void> _savePreferences(Emitter emit) async {
    if(
    _initialBatteryManagerEnabledValue!=state.isBatteryManagerEnabled ||
    _initialBacklightControllerEnabledValue!=state.isBacklightControllerEnabled ||
    _initialBacklightControllerServiceEnabledValue!=state.isBacklightControllerServiceEnabled
    ) {
      emit(state.setState(isLoading: true));
      if (await _disableSettingsRepo.disableServices(
          disable:
          (!state.isBatteryManagerEnabled &&
              !state.isBacklightControllerServiceEnabled)
              ? DisableEnum.service : !state.isBatteryManagerEnabled
              ? DisableEnum.threshold : !state.isBacklightControllerEnabled
              ? super.isMainLine()
              ? DisableEnum.none : DisableEnum.faustus : DisableEnum.none)) {
        await _isarDelegate.saveBatteryAvailability(
            state.isBatteryManagerEnabled);
        await _isarDelegate.saveBacklightAvailability(
            state.isBacklightControllerEnabled);
        await _isarDelegate.saveBacklightServiceAvailability(
            state.isBacklightControllerEnabled &&
                state.isBacklightControllerServiceEnabled);
        super.restartApp();
      } else {
        emit(state.setState(isLoading: false));
      }
      emit(state.setState(isLoading: false));
    }
  }

}
