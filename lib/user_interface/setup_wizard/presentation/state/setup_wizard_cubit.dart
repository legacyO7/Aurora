import 'dart:io';

import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_faustus.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_packages.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_event.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/ar_widgets/arbutton_cubit.dart';
import 'package:aurora/utility/ar_widgets/arsnackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:path_provider/path_provider.dart';

import 'setup_wizard_state.dart';

class SetupWizardCubit extends TerminalBaseBloc<SetupWizardEvent, SetupWizardState> {
  SetupWizardCubit(this._homeRepo, this._setupWizardRepo,this._arButtonCubit) : super(SetupWizardInitState()){
    on<EventSWInit>((_, emit) => _initSetup(emit));
    on<EventSWAllowConfigure>((event, emit) => _allowConfigure(event.allow, emit));
    on<EventSWOnCancel>((event, emit) => _onCancel(stepValue: event.stepValue,emit));
    on<EventSWOnInstall>((event, emit) => _onInstall(stepValue: event.stepValue,emit));
    on<EventSWValidateRepo>((event, emit) => _validateRepo(value: event.url,emit));
  }

  final HomeRepo _homeRepo;
  final SetupWizardRepo _setupWizardRepo;
  final ArButtonCubit _arButtonCubit;

  String? _setupPath;
  String _terminalList = '';

  _initSetup(emit) async {
    Constants.kWorkingDirectory = (await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    Constants.kSecureBootEnabled = await _homeRepo.isSecureBootEnabled();
    await _checkForUpdates(emit);
  }

  Future _checkForUpdates(emit,{bool ignoreUpdate=false}) async {

    navigate(){
      if (_homeRepo.compatibilityChecker()) {
        emit(SetupWizardCompatibleState());
      } else {
        emit(SetupWizardPermissionState());
      }
    }

    if (await _homeRepo.checkInternetAccess()) {
      emit(SetupWizardConnectedState());
      if (false) {
        emit(SetupWizardUpdateAvailableState());
      } else {
        navigate();
      }
    }else{
      navigate();
    }
  }

  _allowConfigure(bool allow,emit){
    if(allow) {
      _emitInstallPackage(emit);
    } else {
      emit(SetupWizardPermissionState());
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
      if (stepValue == 0) {
        await _homeRepo.extractAsset(sourceFileName: Constants.kFaustusInstaller);
        _setupPath = "${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory}";
        _terminalList = '" ${(await _setupWizardRepo.getTerminalList())} "';
        if (_terminalList.isNotEmpty) {

          isSuccess=(await super.getOutput(command: "$_setupPath installpackages $_terminalList")).toString().contains("success")&&_homeRepo.readFile(path: '${Constants.kWorkingDirectory}/log').isEmpty;

        } else {
          arSnackBar(text: "Fetching Data Failed", isPositive: false);
        }
      } else {        
        _emitInstallFaustusTerminal(emit);
        await super.execute("${Constants.kSecureBootEnabled ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.kFaustusGitUrl} $_terminalList");
        isSuccess=_homeRepo.compatibilityChecker();
      }
      _arButtonCubit.setUnLoad();
      _processOutput(emit,state: state,isSuccess: isSuccess,);
    
  }

  _processOutput(emit,{required SetupWizardState state, required bool isSuccess}) {
    if (state is SetupWizardIncompatibleState) {
      if (isSuccess && state.stepValue == 0) {
       _emitInstallFaustus(emit);
      } else if (isSuccess && state.stepValue == 2) {
        emit(SetupWizardCompatibleState());
      } else {
        emit(state.copyState(isValid: true));
        arSnackBar(text: "That didn't go as planned!", isPositive: false);
      }
    }
  }

  void _validateRepo(emit,{required String value}) {
    bool isValid = value.isNotEmpty && value.startsWith('https') && value.endsWith('.git');
    if (isValid) {
      Constants.kFaustusGitUrl = value;
    }
    _emitInstallFaustus(emit,isValid: isValid);
  }

  _emitInstallPackage(emit)=> emit(SetupWizardIncompatibleState(stepValue: 0, child: packageInstaller(), isValid: true));

  _emitInstallFaustus(emit,{bool? isValid})=>  emit(SetupWizardIncompatibleState(stepValue: 1, child: const FaustusInstaller(),isValid: isValid??true));

  _emitInstallFaustusTerminal(emit)=> emit(SetupWizardIncompatibleState(stepValue: 2, child: const TerminalScreen(), isValid: true));

}
