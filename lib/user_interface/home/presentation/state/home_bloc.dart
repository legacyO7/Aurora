import 'package:aurora/shared/shared.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:flutter/foundation.dart';

import 'home_state.dart';

class HomeBloc extends TerminalBaseBloc<HomeEvent,HomeState> {
  final HomeRepo _homeRepo;
  final PermissionManager _permissionManager;
  
  final GlobalConfig _globalConfig=Constants.globalConfig;

  HomeBloc(this._homeRepo, this._permissionManager) : super(const HomeState.init()){
    on<HomeEventInit>((_, emit) => _initHome(emit));
    on<HomeEventRequestAccess>((_, emit) => _requestAccess(emit));
    on<HomeEventRunAsRoot>((_, __) => _selfElevate());
    on<HomeEventLaunch>((event, __) => _launchUrl(subPath: event.url));
    on<HomeEventEnableLogging>((_, emit) => _enableLogging(emit));
    on<HomeEventEnforcement>((event, emit) => _enforcement(emit,enforcement: event.enforcement));
  }

  Future _initHome(emit) async{
    emit(const HomeState.init());
    await _permissionManager.validatePaths();
    emit(state.setState(deniedList: _permissionManager.deniedList));
    await _requestAccess(emit);
  }

  Future _selfElevate() async{
    await _homeRepo.selfElevate();
  }

  Future _requestAccess(emit) async {
    bool hasAccess =await _homeRepo.requestAccess();
    if((!hasAccess && await _homeRepo.canElevate()) || hasAccess) {
      emit(HomeState.accessGranted(hasAccess: hasAccess));
    }else {
      emit(state.setState(state: HomeStates.cannotElevate));
    }
  }

  Future _enforcement(emit,{required Enforcement enforcement}) async{
    super.setLoad();
    if(await _homeRepo.enforcement(enforcement)){
      super.setUnLoad();
      super.restartApp();
    }
  }

  void _enableLogging(emit){
    _globalConfig.isLoggingEnabled=!_globalConfig.isLoggingEnabled;
    if(!kDebugMode) {
      InitAurora().initLogger();
    }
    emit(state.setState(loggingEnabled: _globalConfig.isLoggingEnabled));
  }

  void _launchUrl({String? subPath})async{
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void setAppHeight()=>_homeRepo.setAppHeight();

  List<String> get deniedList=>_permissionManager.deniedList;

}
