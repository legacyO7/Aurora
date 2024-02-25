
import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:aurora/shared/presentation/url_launcher.dart';
import 'package:aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/user_interface/setup/presentation/screens/setup_widgets.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_widgets.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:aurora/utility/global_mixin.dart';

import 'setup_state.dart';

class SetupBloc extends TerminalBaseBloc<SetupEvent, SetupState> with GlobalMixin{
  SetupBloc(this._setupRepo, this._disablerRepo, this._isarDelegate) : super(SetupInitState()){
    on<EventSWInit>((_, emit) => _initSetup(emit));
    on<SetupEventConfigure>((event, emit) => _allowConfigure(event.allow, emit));
    on<SetupEventOnCancel>((event, emit) => _onCancel(stepValue: event.stepValue,emit));
    on<SetupEventOnInstall>((event, emit) => _onInstall(stepValue: event.stepValue,emit));
    on<SetupEventValidateRepo>((event, emit) => _validateRepo(value: event.url,emit));
    on<SetupEventOnUpdate>((event, emit) => _onUpdate(emit,ignoreUpdate: event.ignoreUpdate));
    on<SetupEventBatteryManagerMode>((event, emit) => _enterBatteryManagerMode(emit));
    on<SetupEventCompatibleKernel>((event, emit) => _switchToMainline(emit, removeFaustus: event.removeFaustus));
    on<SetupEventClearCache>((_, emit) => _clearCache(emit));
    on<SetupEventRebirth>((_, emit) => _restart(emit));
    on<SetupEventLaunch>((event, _) => _launchUrl(event.url));
  }

  final SetupRepo _setupRepo;
  final DisableSettingsRepo _disablerRepo;
  final IsarDelegate _isarDelegate;

  final GlobalConfig _globalConfig=Constants.globalConfig;

  _initSetup(emit) async {
    _globalConfig.setInstance(
      isFaustusEnforced: await _setupRepo.isFaustusEnforced(),
      isBatteryManagerEnabled: _isarDelegate.getBatteryManagerAvailability(),
      isBacklightControllerEnabled: _isarDelegate.getBacklightControllerAvailability()
    );
    await getVersion();
    await _setupRepo.initSetup();

    if(!_globalConfig.isBacklightControllerEnabled&&!_globalConfig.isBatteryManagerEnabled){
      emit(SetupPreferenceIncompleteState());
    }else {
      if (_isarDelegate.getVersionFromDB() != _globalConfig.arVersion && await _setupRepo.checkInternetAccess()) {
        emit(SetupWhatsNewState(await _fetchChangelog()));
        await _isarDelegate.saveVersion(_globalConfig.arVersion!);
      } else {
        await _checkForUpdates(emit);
      }
    }
  }

  Future _onUpdate(emit,{bool ignoreUpdate=false})async{
    await _checkForUpdates(emit,ignoreUpdate: ignoreUpdate);
  }

  Future _checkForUpdates(emit,{bool ignoreUpdate=false}) async {

    bool isConnected=await _setupRepo.checkInternetAccess();

    navigate() async {
      switch( await _setupRepo.compatibilityChecker()){
        case 0:
          emit(SetupCompatibleState());
          break;
        case 3:
          emit(SetupBatteryManagerCompatibleState());
          break;
        case 4:
          if(await _setupRepo.checkFaustusFolder()){
            emit(SetupDisableFaustusState());
            await _disablerRepo.disableServices(disable: DisableEnum.faustus);
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
            _emitCompatibility(emit);
          } else {
            emit(SetupAskNetworkAccessState());
          }
      }

      if(_setupRepo.blacklistedConfs.isNotEmpty){
        var prevState=state;
        emit(SetupCompatibleKernelUserBlacklisted(_setupRepo.blacklistedConfs));
        emit(prevState);
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
      var previousState= state;
      emit(SetupDisableFaustusState());
      if(await _disablerRepo.disableServices(disable: DisableEnum.faustus)) {
        emit(SetupRebirth());
      }else{
        emit(previousState);
      }
    }else{
      _globalConfig.setInstance(arMode: ArModeEnum.faustus);
      if(await _setupRepo.checkFaustusFolder()) {
        emit(SetupCompatibleState());
      }else{
        _emitCompatibility(emit);
      }
    }
  }

  void _enterBatteryManagerMode(emit){
    _globalConfig.setInstance(arMode: ArModeEnum.batteryManager);

    emit(SetupCompatibleState());
  }

  Future<bool> _isUpdateAvailable()async{

    if(BuildType.rpm==Constants.buildType) return false;

    var liveVersion=  _setupRepo.convertVersionToInt(await _setupRepo.getAuroraLiveVersion());
    var currentVersion= _setupRepo.convertVersionToInt(_globalConfig.arVersion!);

    if(liveVersion==0||currentVersion==0) {
      return false;
    }

    return liveVersion!=currentVersion;
  }

  Future<String> _fetchChangelog() async{
    return await _setupRepo.getChangelog();
  }

  _allowConfigure(bool allow,emit) async{
    if(allow) {
      await _setupRepo.loadSetupFiles();
      if((await _setupRepo.compatibilityChecker())==1) {
        _emitInstallPackage(emit);
      }else{
        _emitInstallFaustus(emit);
      }
    } else {
      _emitCompatibility(emit);
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
      super.setLoad();


      if (stepValue == 0 ) {
        if((await _setupRepo.compatibilityChecker())!=1) {
          isSuccess = true;
        }else {
          if (await _setupRepo.pkexecChecker()) {
            _emitInstallFaustusTerminal(emit, stepValue: 0);
          }
          await _setupRepo.installPackages();
          isSuccess=await _setupRepo.compatibilityChecker()!=1;
        }
      } else {
          _emitInstallFaustusTerminal(emit,stepValue: 2);
          await _setupRepo.installFaustus();
          switch (await _setupRepo.compatibilityChecker()){
            case 0:
            case 5:
              isSuccess=await _setupRepo.checkFaustusFolder();
              break;
            default:
              isSuccess=false;
          }
      }

      super.setUnLoad();
      await _processOutput(emit,state: state,isSuccess: isSuccess);
    
  }

  _processOutput(emit,{required SetupState state, required bool isSuccess}) async {
    if (state is SetupIncompatibleState) {
      if (isSuccess && state.stepValue == 0) {
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
      _globalConfig.setInstance(
          kFaustusGitUrl:value
      );
    }
    _emitInstallFaustus(emit,isValid: isValid);
  }

  Future _clearCache(emit) async{
    await _isarDelegate.deleteDatabase();
  }

   void _restart(emit) {
    emit(SetupRebirth());
  }

  void _launchUrl(String? url){
    UrlLauncher.launchArUrl(subPath: url);
  }

  void _emitCompatibility(emit){
    if(_globalConfig.isBacklightControllerEnabled) {
      emit(SetupPermissionState());
    }else{
      emit(SetupCompatibleState());
    }
  }

  _emitInstallPackage(emit)  => emit(SetupIncompatibleState(stepValue: 0, child: packageInstaller(packagesToInstall:  _setupRepo.missingPackagesList), isValid: true));

  _emitInstallFaustus(emit,{bool? isValid})=>  emit(SetupIncompatibleState(stepValue: 1, child: const FaustusInstaller(),isValid: isValid??true));

  _emitInstallFaustusTerminal(emit,{required int stepValue})=> emit(SetupIncompatibleState(stepValue: stepValue, child: const TerminalScreen(), isValid: true));

}
