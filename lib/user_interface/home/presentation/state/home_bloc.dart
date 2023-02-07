import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/constants.dart';

import 'home_state.dart';

class HomeBloc extends TerminalBaseBloc<HomeEvent,HomeState> {
  final HomeRepo _homeRepo;
  final BatteryManagerRepo _batteryManagerRepo;
  final PrefRepo _prefRepo;
  
  final _globalConfig=Constants.globalConfig;

  HomeBloc(this._prefRepo, this._homeRepo,this._batteryManagerRepo) : super(HomeStateInit()){
    on<HomeEventRequestAccess>((_, emit) => _requestAccess(emit));
    on<HomeEventLaunch>((event, __) => _launchUrl(subPath: event.url));
    on<HomeEventDispose>((_, emit) => _dispose(emit));
  }

  Future _requestAccess(emit) async {

    _globalConfig.kExecBatteryManagerPath= await _homeRepo.extractAsset(sourceFileName:Constants.kBatteryManager);
    
    if(super.isMainLine()){
      _globalConfig.kExecMainlinePath= await _homeRepo.extractAsset(sourceFileName: Constants.kMainline);
    }else {     
      _globalConfig.kExecFaustusPath=await _homeRepo.extractAsset(sourceFileName: Constants.kFaustus);
    }
    
    var checkAccess=await super.checkAccess();
    if(!checkAccess) {
        await super.execute("${Constants.kPolkit} ${super.isMainLine()? _globalConfig.kExecMainlinePath: _globalConfig
            .kExecFaustusPath} init ${_globalConfig.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
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
      (await _homeRepo.compatibilityChecker())==0&&( await _batteryManagerRepo.getBatteryCharge()!=100);

}
