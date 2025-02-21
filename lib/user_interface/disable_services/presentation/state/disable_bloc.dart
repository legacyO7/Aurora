import 'dart:io';


import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';

import 'disable_state.dart';
import 'disabler_event.dart';

class DisableSettingsBloc extends TerminalBaseBloc<DisableEvent,DisableSettingsState> {
  DisableSettingsBloc(this._disablerRepo, this._isarDelegate) : super(const DisableSettingsState.init()){
    on<DisableEventInit>((_, emit) => emit(const DisableSettingsState.init()));
    on<DisableEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<DisableEventSubmitDisableServices>((_, emit) => _disableServices(emit));
 }

  final DisableSettingsRepo _disablerRepo;
  final IsarDelegate _isarDelegate;


  void _setDisableService(DisableEventCheckDisableServices event, emit) {
      emit(state.setState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule,
        uninstallAurora: event.uninstallAurora
      ));
  }

  Future _disableServices(emit) async{

    super.setLoad();
      DisableEnum disable=DisableEnum.none;
      if(state.uninstallAurora){
        disable=DisableEnum.uninstall;
      }else if(state.disableFaustusModule && state.disableThreshold){
       disable=DisableEnum.all;
      }else if(state.disableFaustusModule){
        disable=DisableEnum.faustus;
      }else if(state.disableThreshold){
        disable=DisableEnum.threshold;
      }else{
        return;
      }

      if(await _disablerRepo.disableServices(disable: disable)) {
        if(state.uninstallAurora){
          exit(0);
        }else{
          if(state.disableThreshold){
            await _isarDelegate.saveBatteryAvailability(false);
          }
          super.restartApp();
        }
      } else{
        arSnackBar(text: "Something went wrong",isPositive: false);
        emit(state.setState(state: DisableStateStates.init));
      }

      super.setUnLoad();
  }

}
