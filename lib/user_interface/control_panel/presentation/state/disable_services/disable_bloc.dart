import 'dart:io';

import 'package:aurora/shared/shared.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';

part 'disable_state.dart';
part 'disabler_event.dart';



class DisablerBloc extends TerminalBaseBloc<DisableEvent,DisableState> {
  DisablerBloc(this._disablerRepo) : super(const DisableState.init()){
    on<DisableEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<DisableEventSubmitDisableServices>((_, emit) => _disableServices(emit));
    on<DisableEventDispose>((_, emit) => _dispose(emit));
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

      emit(state.setState(state: DisableStateStates.terminal));
      if(await _disablerRepo.disableServices(disable: disable)) {
        emit(const DisableState.completed());
        if(state.uninstallAurora){
          exit(0);
        }
      } else{
        arSnackBar(text: "Something went wrong",isPositive: false);
        emit(state.setState(state: DisableStateStates.init));
      }
  }

  void _dispose(emit){
    emit(const DisableState.init());
  }

}
