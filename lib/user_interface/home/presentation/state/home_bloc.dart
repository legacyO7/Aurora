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
    on<HomeEventRequestAccess>((_, emit) => _requestAccess(emit));
    on<HomeEventLaunch>((event, __) => _launchUrl(subPath: event.url));
    on<HomeEventDispose>((_, emit) => _dispose(emit));
  }

  Future _requestAccess(emit) async {

    Constants.globalConfig.setInstance(
        kExecBatteryManagerPath: await _homeRepo.extractAsset(sourceFileName:Constants.kBatteryManager),
        kExecFaustusPath:   await _homeRepo.extractAsset(sourceFileName:Constants.kFaustus)
    );

    var checkAccess=await super.checkAccess();
    if(!checkAccess) {
      await super.execute("${Constants.kPolkit} ${Constants.globalConfig.kExecFaustusPath} init ${Constants.globalConfig.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
      checkAccess=await super.checkAccess();
    }
    emit(AccessGranted(hasAccess: checkAccess));

  }

  void _launchUrl({String? subPath}){
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void _dispose(emit){
    emit(HomeStateInit());
  }

  Future<bool> compatibilityChecker() async=>
      (await _homeRepo.compatibilityChecker())==0&&( await _homeRepo.getBatteryCharge()!=100);

}
