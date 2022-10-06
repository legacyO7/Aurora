import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/state/uninstaller_state.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';

class UninstallerBloc extends TerminalBaseBloc<UninstallEvent,ControlPanelState> {
  UninstallerBloc(this._homeRepo,this._prefRepo) :
        super(const ControlPanelStateInit(disableFaustusModule: false, disableThreshold: false)){
    on<EventUInCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<EventUInSubmitDisableServices>((_, emit) => _disableServices(emit));
  }

  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  void _setDisableService(EventUInCheckDisableServices event, emit) {
    final _state =state;
    if(_state is ControlPanelStateInit) {
      emit(_state.copyState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule
      ));
    }
  }
  
  Future _disableServices(emit) async{
    final _state = state;
    if(_state is ControlPanelStateInit && (_state.disableThreshold || _state.disableFaustusModule)){

      var command="${Constants.kPolkit} ${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory} ";

      if(_state.disableFaustusModule && _state.disableThreshold){
        command+='disablethresholdfaustus';
        _prefRepo.setThreshold(100);
      }else if(_state.disableFaustusModule){
        command+='disablefaustus';
      }else if(_state.disableThreshold){
        command+='disablethreshold';
        _prefRepo.setThreshold(100);
      }
      emit(const ControlPanelTerminalState());
      await super.execute(command);
      emit(ControlPanelStateInit(disableFaustusModule: _state.disableFaustusModule, disableThreshold: _state.disableThreshold));
    }
  }


}
