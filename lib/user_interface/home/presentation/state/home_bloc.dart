import 'package:aurora/data/init_aurora.dart';
import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/foundation.dart';

import 'home_state.dart';

class HomeBloc extends TerminalBaseBloc<HomeEvent,HomeState> {
  final HomeRepo _homeRepo;
  final BatteryManagerRepo _batteryManagerRepo;

  HomeBloc(this._homeRepo,this._batteryManagerRepo) : super(HomeStateInit(loggingEnabled: Constants.isLoggingEnabled)){
    on<HomeEventInit>((_, emit) => _initHome(emit));
    on<HomeEventRequestAccess>((_, emit) => _requestAccess(emit));
    on<HomeEventRunAsRoot>((_, __) => _selfElevate());
    on<HomeEventLaunch>((event, __) => _launchUrl(subPath: event.url));
    on<HomeEventEnableLogging>((_, emit) => _enableLogging(emit));
    on<HomeEventEnforceFaustus>((_, emit) => _enforceFaustus(emit));
    on<HomeEventDispose>((_, emit) => _dispose(emit));
  }

  Future _initHome(emit) async{
    await _requestAccess(emit);
  }

  Future _selfElevate() async{
    await _homeRepo.selfElevate();
  }

  Future _requestAccess(emit) async {
    bool hasAccess =await _homeRepo.requestAccess();
    if((!hasAccess && await _homeRepo.canElevate()) || hasAccess) {
      emit(AccessGranted(hasAccess: hasAccess,loggingEnabled: Constants.isLoggingEnabled));
    }else {
      emit(HomeStateCannotElevate());
    }
  }

  Future _enforceFaustus(emit) async{
    if(await _homeRepo.enforceFaustus()==0){
      Constants.globalConfig.setInstance(arMode: ARMODE.faustus);
      emit(HomeStateRebirth());
    }
  }

  void _enableLogging(emit){
    Constants.isLoggingEnabled=!Constants.isLoggingEnabled;
    if(!kDebugMode) {
      InitAurora().initLogger();
    }
    HomeState state_=state;
    if(state_ is AccessGranted) {
      emit(AccessGranted(hasAccess: state_.hasAccess,loggingEnabled: Constants.isLoggingEnabled));
    }
  }

  void _launchUrl({String? subPath})async{
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void _dispose(emit){
    emit(HomeStateInit(loggingEnabled: Constants.isLoggingEnabled));
  }

  Future<bool> compatibilityChecker() async=>
      (await _homeRepo.compatibilityChecker())==0&&( await _batteryManagerRepo.getBatteryCharge()!=100);

  void setAppHeight()=>_homeRepo.setAppHeight();

}
