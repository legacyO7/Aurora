import 'dart:io';

import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_faustus.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/screens/widgets/install_packages.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'setup_wizard_state.dart';

class SetupWizardCubit extends Cubit<SetupWizardState>{
  SetupWizardCubit(this._terminalRepo,this._homeRepo):super(SetupWizardInitState());

  TerminalRepo _terminalRepo;
  HomeRepo _homeRepo;
  bool _isSuccess=false;
  String? _setupPath;

  bool compatibilityChecker() => Directory('/sys/devices/platform/faustuss/').existsSync();
  
  initSetup()async{
    Constants.kWorkingDirectory=(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    if(compatibilityChecker()) {
      emit(SetupWizardCompatibleState());
    }else{
      emit(SetupWizardIncompatibleState(stepValue: 0,child: packageInstaller()));
    }
  }

  Future<bool> installer() async{
    _listenToTerminal();
    final _state = state;
    if(_state is SetupWizardIncompatibleState){
      if(_state.stepValue==0){
        _setupPath=await _homeRepo.extractAsset(sourceFileName: Constants.kSetup);
        await _terminalRepo.execute("$_setupPath installpackages");
        if(_isSuccess) {
          emit(SetupWizardIncompatibleState(stepValue: 1,child: faustusInstaller()));
        }
      }else if(_state.stepValue==1){
        await _terminalRepo.execute("$_setupPath installfaustus");
        emit(SetupWizardIncompatibleState(stepValue: 2,child: const TerminalScreen()));
      }
    }
    return _isSuccess;
  }

  _listenToTerminal(){
    var ttext=[];
    _terminalRepo.terminalOutStream.listen((event) async{
      for (var element in event) {
       ttext.add(element.text.trim());
      }
      _isSuccess=ttext.contains("success");
    });
  }

  bool get isSuccess => _isSuccess;
}