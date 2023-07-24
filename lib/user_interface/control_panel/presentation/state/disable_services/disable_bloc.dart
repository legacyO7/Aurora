import 'dart:io';

import 'package:aurora/shared/shared.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:equatable/equatable.dart';

part 'disable_state.dart';
part 'disabler_event.dart';



class DisableSettingsBloc extends TerminalBaseBloc<DisableEvent,DisableSettingsState> {
  DisableSettingsBloc(this._disablerRepo) : super(const DisableSettingsState.init()){
    on<DisableEventInit>((_, emit) => emit(const DisableSettingsState.init()));
    on<DisableEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<DisableEventSubmitDisableServices>((_, emit) => _disableServices(emit));
 }

  final DisableSettingsRepo _disablerRepo;


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
      }

      if(await _disablerRepo.disableServices(disable: disable)) {
       // await close();
        if(state.uninstallAurora){
          exit(0);
        }else{
          super.restartApp();
        }
      } else{
        arSnackBar(text: "Something went wrong",isPositive: false);
        emit(state.setState(state: DisableStateStates.init));
      }

      super.setUnLoad();
  }

}
