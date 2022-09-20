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

  bool compatibilityChecker() => Directory('/sys/devices/platform/faustuss/').existsSync();
  
  initSetup()async{
    Constants.kWorkingDirectory=(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    if(compatibilityChecker()) {
      emit(SetupWizardCompatibleState());
    }else{
      emit(SetupWizardIncompatibleState(stepValue: 0,child: packageInstaller(),isValid: true));
    }
  }

  Future<bool> installer(context) async{
    final _state = state;
    if(_state is SetupWizardIncompatibleState){
      emit(SetupWizardIncompatibleState(stepValue: _state.stepValue,child: _state.child,inProgress: true));
      if(_state.stepValue==0){
        _listenToTerminal();
        var terminalList=await _setupWizardRepo.getTerminalList();
        if(terminalList.isNotEmpty){
         _setupPath="${await _homeRepo.extractAsset(sourceFileName: Constants.kSetup)} ${Constants.kWorkingDirectory}";
          await _terminalRepo.execute("$_setupPath installpackages $terminalList");
        }else{
          arSnackBar( text: "Fetching Data Failed",isPositive: false);
        }
        if(_isSuccess) {
          emit(SetupWizardIncompatibleState(stepValue: 1,child: const FaustusInstaller()));
        }else{
          emit(SetupWizardIncompatibleState(stepValue: _state.stepValue,child: _state.child));
          arSnackBar( text: "That didn't go as planned!",isPositive: false);
        }
      }else if(_state.stepValue==1){
        await _terminalRepo.execute("$_setupPath installfaustus");
        emit(SetupWizardIncompatibleState(stepValue: 2,child: const TerminalScreen()));
      }
    }
    return _isSuccess;
  }

  validateRepo(String value){
    emit(SetupWizardIncompatibleState(stepValue: 1,child: const FaustusInstaller(),isValid: value.isNotEmpty&&value.startsWith('https')&&value.endsWith('.git')));
  }

  _listenToTerminal(){
    var extractedText=[];
    _terminalRepo.terminalOutStream.listen((event) async{
      for (var element in event) {
       extractedText.add(element.text.trim());
      }
       _isSuccess=extractedText.contains("success")&& _homeRepo.readFile(path: '${Constants.kWorkingDirectory}/log').isEmpty;
    });
  }

  bool get isSuccess => _isSuccess;
}