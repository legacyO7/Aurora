import 'dart:io';

import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_faustus.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_packages.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/arsnackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'setup_wizard_state.dart';

class SetupWizardCubit extends Cubit<SetupWizardState>{
  SetupWizardCubit(this._terminalRepo,this._homeRepo,this._setupWizardRepo):super(SetupWizardInitState());

  final TerminalRepo _terminalRepo;
  final HomeRepo _homeRepo;
  final SetupWizardRepo _setupWizardRepo;
  
  bool _isSuccess=false;
  String? _setupPath;
  String terminalList='';

  late var _subscription;

  bool compatibilityChecker() => Directory('/sys/devices/platform/faustus/').existsSync();
  
  initSetup()async{
    Constants.kWorkingDirectory=(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    Constants.kSecureBootEnabled=await _homeRepo.isSecureBootEnabled();
    if(compatibilityChecker()) {
      emit(SetupWizardCompatibleState());
    }else{
      emit(SetupWizardIncompatibleState(stepValue: 0,child: packageInstaller(),isValid: true));
    }
  }

 installer(context) async{
    final _state = state;
    if(_state is SetupWizardIncompatibleState){
      emit(SetupWizardIncompatibleState(stepValue: _state.stepValue,child: _state.child,inProgress: true));
      if(_state.stepValue==0){
        _listenToTerminal();
        await _homeRepo.extractAsset(sourceFileName: Constants.kFaustusInstaller);
        _setupPath="${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.kWorkingDirectory}";
        terminalList='" ${(await _setupWizardRepo.getTerminalList())} "';
        if(terminalList.isNotEmpty){
          await _terminalRepo.execute("$_setupPath installpackages $terminalList");
        }else{
          arSnackBar( text: "Fetching Data Failed",isPositive: false);
        }
      }else{
        _state.stepValue=2;
        _state.child=const TerminalScreen();
        emit(SetupWizardIncompatibleState(stepValue: _state.stepValue, child: _state.child,inProgress: true,isValid: true));
        await _terminalRepo.execute("${Constants.kSecureBootEnabled?'':Constants.kPolkit} $_setupPath installfaustus ${Constants.kFaustusGitUrl} $terminalList");
      }
      processOutput(_state);
    }
  }

  processOutput(SetupWizardIncompatibleState state){
    if(_isSuccess && state.stepValue==0) {
      emit(SetupWizardIncompatibleState(stepValue: 1,child: const FaustusInstaller()));
    }else if(_isSuccess && state.stepValue==2){
      _subscription.cancel();
      emit(SetupWizardCompatibleState());
    }else{
      emit(SetupWizardIncompatibleState(stepValue: state.stepValue,child: state.child,isValid: state.isValid));
      arSnackBar( text: "That didn't go as planned!",isPositive: false);
    }
  }

  validateRepo(String value){
    bool isValid= value.isNotEmpty&&value.startsWith('https')&&value.endsWith('.git');
    if(isValid){
      Constants.kFaustusGitUrl=value;
    }
    emit(SetupWizardIncompatibleState(stepValue: 1,child: const FaustusInstaller(),isValid:isValid));
  }

  _listenToTerminal(){

    var extractedText=[];
    _subscription= _terminalRepo.terminalOutStream.listen((event) async{
      final _state = state;
      for (var element in event) {
       extractedText.add(element.text.trim());
      }

      if(_state is SetupWizardIncompatibleState){
        if (_state.stepValue==0) {
          _isSuccess = extractedText.contains("success") && _homeRepo.readFile(path: '${Constants.kWorkingDirectory}/log').isEmpty;
        } else if (_state.stepValue==2) {
          _isSuccess = extractedText.contains("faustus module found");
        }
      }
    });
  }

  bool get isSuccess => _isSuccess;
}