import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState> {
  final TerminalRepo _terminalRepo;
  final PrefRepo _prefRepo;

  HomeCubit(this._terminalRepo,this._prefRepo) : super(HomeStateInit()) {
    _terminalRepo.terminalOutStream.listen((event) {
      emit(AccessGranted(terminalOut: event, inProgress: _terminalRepo.isInProgress(), hasRootAccess: _terminalRepo.checkRootAccess()));
    });
  }

  final String _assetPath = "assets/scripts/";


  Future getVersion() async{
    Constants.arVersion= (await PackageInfo.fromPlatform()).version;
  }

  Future execute(String command) async {
    await _terminalRepo.execute(command);
  }

  Future initScript({required String sourceFileName}) async {
    final byteData = await rootBundle.load('$_assetPath/$sourceFileName');
    var destinationFileName = "${Constants.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await execute("chmod +x $destinationFileName");
    return destinationFileName;
  }

  void requestAccess() async {

    await getVersion();
    Constants.kWorkingDirectory=(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path;
    Constants.kExecBatteryManagerPath=await initScript(sourceFileName:Constants.kBatteryManager);
    Constants.kExecFaustusPath=await initScript(sourceFileName:Constants.kFaustus);

    await execute("${Constants.kPolkit} ${Constants.kExecFaustusPath} init ${Constants.kWorkingDirectory} ${await _prefRepo.getThreshold()}");

  }

  void killProcess() {
    _terminalRepo.killProcess();
  }
}
