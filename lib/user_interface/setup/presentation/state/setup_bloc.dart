import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/domain/uninstaller/disabler_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_widgets.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'setup_state.dart';

class SetupBloc extends TerminalBaseBloc<SetupEvent, SetupState> {
  SetupBloc(this._homeRepo,this._prefRepo, this._setupWizardRepo,this._arButtonCubit, this._disablerRepo) : super(SetupInitState()){
    on<EventSWInit>((_, emit) => _initSetup(emit));
    on<SetupEventConfigure>((event, emit) => _allowConfigure(event.allow, emit));
    on<SetupEventOnCancel>((event, emit) => _onCancel(stepValue: event.stepValue,emit));
    on<SetupEventOnInstall>((event, emit) => _onInstall(stepValue: event.stepValue,emit));
    on<SetupEventValidateRepo>((event, emit) => _validateRepo(value: event.url,emit));
    on<SetupEventOnUpdate>((event, emit) => _onUpdate(emit,ignoreUpdate: event.ignoreUpdate));
    on<SetupEventBatteryManagerMode>((event, emit) => _enterBatteryManagerMode(emit));
    on<SetupEventCompatibleKernel>((event, emit) => _switchToMainline(emit, removeFaustus: event.removeFaustus));
  }

  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;
  final SetupRepo _setupWizardRepo;
  final ArButtonCubit _arButtonCubit;
  final DisablerRepo _disablerRepo;

  _initSetup(emit) async {
    await _homeRepo.getVersion();
    await _setupWizardRepo.initSetup();

    if(await _prefRepo.getVersion() !=Constants.globalConfig.arVersion && await _homeRepo.checkInternetAccess()){
      emit(SetupWhatsNewState(await _fetchChangelog()));
      await _prefRepo.setVersion(Constants.globalConfig.arVersion!);
    }else {
      await _checkForUpdates(emit);
    }
  }

  Future _onUpdate(emit,{bool ignoreUpdate=false})async{
    await _checkForUpdates(emit,ignoreUpdate: ignoreUpdate);
  }

  Future _checkForUpdates(emit,{bool ignoreUpdate=false}) async {

    bool isConnected=await _homeRepo.checkInternetAccess();

    navigate() async {
      switch( await _homeRepo.compatibilityChecker()){
        case 0:
          emit(SetupCompatibleState());
          break;
        case 3:
          emit(SetupBatteryManagerCompatibleState());
          break;
        case 4:
          if(_homeRepo.checkFaustusFolder()){
            emit(SetupDisableFaustusState());
            await _disablerRepo.disableServices(disable: DISABLE.faustus);
          }
            emit(SetupMainlineCompatibleState());
          break;

        case 5:
          emit(SetupCompatibleKernel());
          break;

        case 6:
          emit(SetupMissingPkexec());
          break;
          
        case 7:
          emit(SetupInCompatibleDevice());
          break;

        default:
          if(isConnected) {
            emit(SetupPermissionState());
          } else {
            emit(SetupAskNetworkAccessState());
          }
      }
    }

    if (isConnected && !ignoreUpdate) {
      emit(SetupConnectedState());
      if (await _isUpdateAvailable()) {
        emit(SetupUpdateAvailableState(await _fetchChangelog()));
      } else {
        await navigate();
      }
    }else{
       await navigate();
    }
  }

  Future _switchToMainline(emit,{required bool removeFaustus}) async{
    if(removeFaustus){
      emit(SetupDisableFaustusState());
      await _disablerRepo.disableServices(disable: DISABLE.faustus);
      Phoenix.rebirth(Constants.kScaffoldKey.currentState!.context);
    }else{
      Constants.globalConfig.setInstance(arMode: ARMODE.normal);
      emit(SetupCompatibleState());
    }
  }

  void _enterBatteryManagerMode(emit){
    Constants.globalConfig.setInstance(arMode: ARMODE.batteryManager);
    emit(SetupCompatibleState());
  }

  Future<bool> _isUpdateAvailable()async{

    if(BuildType.appimage!=Constants.buildType) return false;

    var liveVersion=  _homeRepo.convertVersionToInt(await _setupWizardRepo.getAuroraLiveVersion());
    var currentVersion= _homeRepo.convertVersionToInt(Constants.globalConfig.arVersion!);

    if(liveVersion==0||currentVersion==0) {
      return false;
    }

    return liveVersion!=currentVersion;
  }

  Future<String> _fetchChangelog() async{
    return await _setupWizardRepo.getChangelog();
  }

  _allowConfigure(bool allow,emit) async{
    if(allow) {
      await _setupWizardRepo.loadSetupFiles();
      if((await _homeRepo.compatibilityChecker())==1) {
        _emitInstallPackage(emit);
      }else{
        _emitInstallFaustus(emit);
      }
    } else {
      emit(SetupPermissionState());
    }
  }

  void _onCancel(emit,{required int stepValue}){
    if(stepValue==0) {
      _allowConfigure(false,emit);
    } else if(stepValue==1){
      _emitInstallPackage(emit);
    }else if(stepValue==2){
      _emitInstallFaustus(emit);
    }
  }

  void _onInstall(emit,{required int stepValue}) async {
      var isSuccess=false;
      _arButtonCubit.setLoad();


      if (stepValue == 0 ) {
        if((await _homeRepo.compatibilityChecker())!=1) {
          isSuccess = true;
        }else {
          if (await _setupWizardRepo.pkexecChecker()) {
            _emitInstallFaustusTerminal(emit, stepValue: 0);
          }
          await _setupWizardRepo.installPackages();
        }
      } else {
          _emitInstallFaustusTerminal(emit,stepValue: 2);
          await _setupWizardRepo.installFaustus();
          switch (await _homeRepo.compatibilityChecker()){
            case 0:
            case 5:
              isSuccess=true;
              break;
            default:
              isSuccess=false;
          }
      }

      _arButtonCubit.setUnLoad();
      await _processOutput(emit,state: state,isSuccess: isSuccess);
    
  }

  _processOutput(emit,{required SetupState state, required bool isSuccess}) async {
    if (state is SetupIncompatibleState) {
      if (isSuccess && state.stepValue == 0 && await _homeRepo.compatibilityChecker()!=1) {
       _emitInstallFaustus(emit);
      } else if (isSuccess && state.stepValue == 2) {
        emit(SetupCompatibleState());
      } else {
        emit(state.copyState(isValid: true));
        arSnackBar(text: "That didn't go as planned!", isPositive: false);
      }
    }
  }

  void _validateRepo(emit,{required String value}) {
    bool isValid = value.isNotEmpty && value.startsWith('http') && value.endsWith('.git');
    if (isValid) {
      Constants.globalConfig.setInstance(
          kFaustusGitUrl:value
      );
    }
    _emitInstallFaustus(emit,isValid: isValid);
  }

  _emitInstallPackage(emit)  => emit(SetupIncompatibleState(stepValue: 0, child: packageInstaller(packagesToInstall:  _setupWizardRepo.missingPackagesList), isValid: true));

  _emitInstallFaustus(emit,{bool? isValid})=>  emit(SetupIncompatibleState(stepValue: 1, child: const FaustusInstaller(),isValid: isValid??true));

  _emitInstallFaustusTerminal(emit,{required int stepValue})=> emit(SetupIncompatibleState(stepValue: stepValue, child: const TerminalScreen(), isValid: true));

}
