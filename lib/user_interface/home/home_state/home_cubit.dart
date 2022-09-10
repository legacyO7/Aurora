import 'dart:io';

import 'package:aurora/data/di/shared_preference/pref_constants.dart';
import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState>{
  final TerminalRepo _terminalRepo;

  HomeCubit(this._terminalRepo) : super(HomeStateInit()){
    _terminalRepo.terminalOutStream.listen((event) {
      emit(AccessGranted(terminalOut: event, inProgress: _terminalRepo.isInProgress(), hasRootAccess:_terminalRepo.checkRootAccess()));
    });
  }

  final String _filename="faustus_controller.sh";
  final String _assetPath="assets/scripts/";

  String _executionFile='';

  Future execute(String command) async {
    await _terminalRepo.execute(command);
  }

  Future initScript() async{
    final byteData = await rootBundle.load('$_assetPath/$_filename');
    _executionFile = "${(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path}/$_filename";

     await File(_executionFile).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  initTerminal(Map<String,dynamic> initData)async{
      await setBrightness(initData[PrefConstants.brightness]);
      await setColor(initData[PrefConstants.color]);
      await setMode(initData[PrefConstants.mode]);
      await setSpeed(initData[PrefConstants.speed]);
  }

  void requestAccess() async{
    await initScript();
    await execute("chmod +x $_executionFile");
    await execute("pkexec $_executionFile");
  }

  Future<bool> setColor(color) async{
    await execute("$_executionFile color ${color.red.toRadixString(16)} ${color.green.toRadixString(16)} ${color.blue.toRadixString(16)} 0");
    return _terminalRepo.checkRootAccess();
  }

  Future<bool> setBrightness(value) async{
    await execute("$_executionFile brightness $value ");
    return _terminalRepo.checkRootAccess();
  }

  Future<bool> setMode(value) async{
    await execute("$_executionFile mode $value ");
    return _terminalRepo.checkRootAccess();
  }

  Future<bool> setSpeed(value) async{
    await execute("$_executionFile speed $value ");
    return _terminalRepo.checkRootAccess();
  }

  void killProcess(){
    _terminalRepo.killProcess();
  }
}