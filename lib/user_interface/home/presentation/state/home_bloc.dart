import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';

import 'home_state.dart';

class HomeBloc extends TerminalBaseBloc<HomeEvent,HomeState> {
  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  HomeBloc(this._prefRepo, this._homeRepo) : super(HomeStateInit()){
    on<EventHRequestAccess>((_, emit) => _requestAccess(emit));
    on<EventHLaunchUrl>((event, __) => _launchUrl(subPath: event.url));
  }

  Future _requestAccess(emit) async {
    
    Constants.kExecBatteryManagerPath=await _homeRepo.extractAsset(sourceFileName:Constants.kBatteryManager);
    Constants.kExecFaustusPath=await _homeRepo.extractAsset(sourceFileName:Constants.kFaustus);

    var checkAccess=await super.checkAccess();
    if(!checkAccess) {
      await super.execute("${Constants.kPolkit} ${Constants.kExecFaustusPath} init ${Constants.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
      checkAccess=await super.checkAccess();
    }
    emit(AccessGranted(hasAccess: checkAccess));

  }

  void _launchUrl({String? subPath}){
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void dispose(){
    emit(HomeStateInit());
  }

}
