import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_state.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';

class UninstallerBloc extends TerminalBaseBloc<UninstallEvent,ControlPanelState> {
  UninstallerBloc(this._homeRepo,this._prefRepo) :
        super(const ControlPanelStateInit(disableFaustusModule: false, disableThreshold: false)){
    on<UninstallEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<UninstallEventSubmitDisableServices>((_, emit) => _disableServices(emit));
  }

  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  void _setDisableService(UninstallEventCheckDisableServices event, emit) {
    final state_ =state;
    if(state_ is ControlPanelStateInit) {
      emit(state_.copyState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule
      ));
    }
  }
  
  Future _disableServices(emit) async{
    final state_ = state;
    if(state_ is ControlPanelStateInit && (state_.disableThreshold || state_.disableFaustusModule)){

      var command="${Constants.kPolkit} ${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory} ";

      if(state_.disableFaustusModule && state_.disableThreshold){
        command+='disablethresholdfaustus';
        _prefRepo.setThreshold(100);
      }else if(state_.disableFaustusModule){
        command+='disablefaustus';
      }else if(state_.disableThreshold){
        command+='disablethreshold';
        _prefRepo.setThreshold(100);
      }
      emit(const ControlPanelTerminalState());
      await super.execute(command);
      emit(ControlPanelStateInit(disableFaustusModule: state_.disableFaustusModule, disableThreshold: state_.disableThreshold));
    }
  }


}
