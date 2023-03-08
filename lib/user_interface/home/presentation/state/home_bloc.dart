import 'package:aurora/user_interface/control_panel/domain/battery_manager/battery_manager_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';

import 'home_state.dart';

class HomeBloc extends TerminalBaseBloc<HomeEvent,HomeState> {
  final HomeRepo _homeRepo;
  final BatteryManagerRepo _batteryManagerRepo;

  HomeBloc(this._homeRepo,this._batteryManagerRepo) : super(HomeStateInit()){
    on<HomeEventInit>((_, emit) => _initHome(emit));
    on<HomeEventRequestAccess>((_, emit) => _requestAccess(emit));
    on<HomeEventLaunch>((event, __) => _launchUrl(subPath: event.url));
    on<HomeEventDispose>((_, emit) => _dispose(emit));
  }

  Future _initHome(emit) async{
    await _homeRepo.loadScripts();
    await _requestAccess(emit);
  }

  Future _requestAccess(emit) async {
    emit(AccessGranted(hasAccess: await _homeRepo.requestAccess()));
  }

  void _launchUrl({String? subPath})async{
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void _dispose(emit){
    emit(HomeStateInit());
  }

  Future<bool> compatibilityChecker() async=>
      (await _homeRepo.compatibilityChecker())==0&&( await _batteryManagerRepo.getBatteryCharge()!=100);

  void setAppHeight()=>_homeRepo.setAppHeight();

}
