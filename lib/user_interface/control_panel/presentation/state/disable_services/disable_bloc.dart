import 'dart:io';

import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo.dart';
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

  final DisablerRepo _disablerRepo;

  void _setDisableService(DisableEventCheckDisableServices event, emit) {
      emit(state.setState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule,
        uninstallAurora: event.uninstallAurora
      ));
  }

  Future _disableServices(emit) async{
      DISABLE disable=DISABLE.none;
      if(state.uninstallAurora){
        disable=DISABLE.uninstall;
      }else if(state.disableFaustusModule && state.disableThreshold){
       disable=DISABLE.all;
      }else if(state.disableFaustusModule){
        disable=DISABLE.faustus;
      }else if(state.disableThreshold){
        disable=DISABLE.threshold;
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
