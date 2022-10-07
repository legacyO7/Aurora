import 'dart:io';

import 'package:aurora/user_interface/control_panel/state/keyboard_settings_event.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_faustus.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_packages.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/ar_widgets/arsnackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:path_provider/path_provider.dart';

import 'setup_wizard_state.dart';

class SetupWizardCubit extends TerminalBaseBloc<KeyboardSettingsEvent, SetupWizardState> {
  SetupWizardCubit(this._homeRepo, this._setupWizardRepo) : super(SetupWizardInitState());

  final HomeRepo _homeRepo;
  final SetupWizardRepo _setupWizardRepo;

  String? _setupPath;
  String terminalList = '';

  initSetup() async {
    Constants.kWorkingDirectory = (await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    Constants.kSecureBootEnabled = await _homeRepo.isSecureBootEnabled();
    await checkForUpdates();
  }

  Future checkForUpdates({bool ignoreUpdate=false}) async {

    _navigate(){
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
        _navigate();
      }
    }else{
      _navigate();
    }
  }

  allowConfigure(bool allow){
    if(allow) {
      _emitInstallPackage();
    } else {
      emit(SetupWizardPermissionState());
    }
  }
  
  _emitInstallPackage()=> emit(SetupWizardIncompatibleState(stepValue: 0, child: packageInstaller(), isValid: true));
  
  _emitInstallFaustus()=>  emit(SetupWizardIncompatibleState(stepValue: 1, child: const FaustusInstaller(),isValid: true));
  
  _emitInstallFaustusTerminal()=> emit(SetupWizardIncompatibleState(stepValue: 2, child: const TerminalScreen(), isValid: true));

  void handleCancel({required int stepValue}){
    if(stepValue==0) {
      allowConfigure(false);
    } else if(stepValue==1){
      _emitInstallPackage();
    }else if(stepValue==2){
      _emitInstallFaustus();
    }
  }

  installer(context) async {
    final _state = state;
    if (_state is SetupWizardIncompatibleState) {
      emit(SetupWizardIncompatibleState());
      var _isSuccess=false;
      if (_state.stepValue == 0) {
        await _homeRepo.extractAsset(sourceFileName: Constants.kFaustusInstaller);
        _setupPath = "${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory}";
        terminalList = '" ${(await _setupWizardRepo.getTerminalList())} "';
        if (terminalList.isNotEmpty) {

          _isSuccess=(await super.getOutput(command: "$_setupPath installpackages $terminalList")).toString().contains("success")&&_homeRepo.readFile(path: '${Constants.kWorkingDirectory}/log').isEmpty;

        } else {
          arSnackBar(text: "Fetching Data Failed", isPositive: false);
        }
      } else {        
        _emitInstallFaustusTerminal();
        await super.execute("${Constants.kSecureBootEnabled ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.kFaustusGitUrl} $terminalList");
        _isSuccess=_homeRepo.compatibilityChecker();
      }
      processOutput(state: state,isSuccess: _isSuccess);
    }
  }

  processOutput({required SetupWizardState state, required bool isSuccess}) {
    if (state is SetupWizardIncompatibleState) {
      if (isSuccess && state.stepValue == 0) {
       _emitInstallFaustus();
      } else if (isSuccess && state.stepValue == 2) {
        emit(SetupWizardCompatibleState());
      } else {
        emit(state.copyState(isValid: true));
        arSnackBar(text: "That didn't go as planned!", isPositive: false);
      }
    }
  }

  validateRepo(String value) {
    bool isValid = value.isNotEmpty && value.startsWith('https') && value.endsWith('.git');
    if (isValid) {
      Constants.kFaustusGitUrl = value;
    }
    emit(SetupWizardIncompatibleState(stepValue: 1, child: const FaustusInstaller(), isValid: isValid));
  }

}
