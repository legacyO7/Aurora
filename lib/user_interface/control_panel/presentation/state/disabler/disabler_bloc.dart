import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_state.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

enum DISABLE {faustus, threshold, all, none}

class DisablerBloc extends TerminalBaseBloc<DisableEvent,DisableState> {
  DisablerBloc(this._disablerRepo) :
        super(DisableInitState(disableFaustusModule: false, disableThreshold: false)){
    on<DisableEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<DisableEventSubmitDisableServices>((_, emit) => _disableServices(emit));
    on<DisableEventDispose>((_, emit) => _dispose(emit));
  }

  final DisablerRepo _disablerRepo;

  void _setDisableService(DisableEventCheckDisableServices event, emit) {
    final state_ =state;
    if(state_ is DisableInitState) {
      emit(state_.copyState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule
      ));
    }
  }

  Future _disableServices(emit) async{
    final state_ = state;
    if(state_ is DisableInitState && (state_.disableThreshold || state_.disableFaustusModule)){
      emit(DisableTerminalState());
      DISABLE disable=DISABLE.none;
      if(state_.disableFaustusModule && state_.disableThreshold){
       disable=DISABLE.all;
      }else if(state_.disableFaustusModule){
        disable=DISABLE.faustus;
      }else if(state_.disableThreshold){
        disable=DISABLE.threshold;
      }
      await _disablerRepo.disableServices(disable: disable);
      emit(DisableProcessCompletedState());
      Phoenix.rebirth(Constants.kScaffoldKey.currentContext!);
    }
  }

  void _dispose(emit){
    emit(DisableInitState(disableFaustusModule: false,disableThreshold: false));
  }

}
