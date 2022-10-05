import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/state/control_panel_state.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:equatable/equatable.dart';

class ControlPanelCubit extends TerminalBaseCubit<Equatable> {
  ControlPanelCubit(this._homeRepo,this._prefRepo) : super(const ControlPanelStateInit(disableFaustusModule: false, disableThreshold: false));

  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  void setDisableService({bool? disableThreshold, bool? disableFaustusModule}) {
    final _state = state;
    if (_state is ControlPanelStateInit) {
      emit(ControlPanelStateInit(disableThreshold: disableThreshold??_state.disableThreshold, disableFaustusModule: disableFaustusModule?? _state.disableFaustusModule));
    }
  }
  
  Future disableServices() async{
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
