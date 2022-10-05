import 'dart:io';

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

class SetupWizardCubit extends TerminalBaseCubit<SetupWizardState> {
  SetupWizardCubit(this._homeRepo, this._setupWizardRepo) : super(SetupWizardInitState());

  final HomeRepo _homeRepo;
  final SetupWizardRepo _setupWizardRepo;

  bool _isSuccess = false;
  String? _setupPath;
  String terminalList = '';

  late var _subscription;

  bool compatibilityChecker() => Directory('/sys/devices/platform/faustus/').existsSync();

  initSetup() async {
    Constants.kWorkingDirectory = (await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    Constants.kSecureBootEnabled = await _homeRepo.isSecureBootEnabled();
    await checkForUpdates();
  }

  Future checkForUpdates({bool ignoreUpdate=false}) async {

    _navigate(){
      if (compatibilityChecker()) {
        emit(SetupWizardCompatibleState());
      } else {
        emit(SetupWizardIncompatibleState(stepValue: 0, child: packageInstaller(), isValid: true));
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

  installer(context) async {
    final _state = state;
    if (_state is SetupWizardIncompatibleState) {
      emit(SetupWizardIncompatibleState());
      if (_state.stepValue == 0) {
        _listenToTerminal();
        await _homeRepo.extractAsset(sourceFileName: Constants.kFaustusInstaller);
        _setupPath = "${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory}";
        terminalList = '" ${(await _setupWizardRepo.getTerminalList())} "';
        if (terminalList.isNotEmpty) {
          await super.execute("$_setupPath installpackages $terminalList");
        } else {
          arSnackBar(text: "Fetching Data Failed", isPositive: false);
        }
      } else {
        emit(_state.copyState(child: const TerminalScreen(), stepValue: 2, isValid: true));

        await super.execute("${Constants.kSecureBootEnabled ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.kFaustusGitUrl} $terminalList");
      }
      processOutput(state);
    }
  }

  processOutput(SetupWizardState state) {
    if (state is SetupWizardIncompatibleState) {
      if (_isSuccess && state.stepValue == 0) {
        emit(SetupWizardIncompatibleState(stepValue: 1, child: const FaustusInstaller()));
      } else if (_isSuccess && state.stepValue == 2) {
        _subscription.cancel();
        emit(SetupWizardCompatibleState());
      } else {
        emit(state);
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

  _listenToTerminal() {
    _subscription = super.terminalOutput.listen((event) async {
      final _state = state;
      if (_state is SetupWizardIncompatibleState) {
        if (_state.stepValue == 0) {
          _isSuccess = event.any((element) => element.contains("success")) && _homeRepo.readFile(path: '${Constants.kWorkingDirectory}/log').isEmpty;
        } else if (_state.stepValue == 2) {
          _isSuccess = event.any((element) => element.contains("faustus module found"));
        }
      }
    });
  }

  bool get isSuccess => _isSuccess;
}
