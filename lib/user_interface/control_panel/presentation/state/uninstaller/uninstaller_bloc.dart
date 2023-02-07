import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_event.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/uninstaller/uninstaller_state.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';

class UninstallerBloc extends TerminalBaseBloc<UninstallEvent,UninstallState> {
  UninstallerBloc(this._homeRepo,this._prefRepo) :
        super(UninstallInitState(disableFaustusModule: false, disableThreshold: false)){
    on<UninstallEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<UninstallEventSubmitDisableServices>((_, emit) => _disableServices(emit));
    on<UninstallEventDispose>((_, emit) => _dispose(emit));
  }

  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  void _setDisableService(UninstallEventCheckDisableServices event, emit) {
    final state_ =state;
    if(state_ is UninstallInitState) {
      emit(state_.copyState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule
      ));
    }
  }

  Future _disableServices(emit) async{
    final state_ = state;
    if(state_ is UninstallInitState && (state_.disableThreshold || state_.disableFaustusModule)){

      var command="${Constants.kPolkit} ${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.globalConfig.kWorkingDirectory} ";

      if(state_.disableFaustusModule && state_.disableThreshold){
        command+='disablethresholdfaustus';
        _prefRepo.setThreshold(100);
      }else if(state_.disableFaustusModule){
        command+='disablefaustus';
      }else if(state_.disableThreshold){
        command+='disablethreshold';
        _prefRepo.setThreshold(100);
      }
      emit(UninstallTerminalState());
      await super.execute(command);
      emit(UninstallProcessCompletedState());
    }
  }

  void _dispose(emit){
    emit(UninstallInitState(disableFaustusModule: false,disableThreshold: false));
  }

}
