import 'dart:io';

import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState> {
  final TerminalRepo _terminalRepo;

  HomeCubit(this._terminalRepo) : super(HomeStateInit()) {
    _terminalRepo.terminalOutStream.listen((event) {
      emit(AccessGranted(terminalOut: event, inProgress: _terminalRepo.isInProgress(), hasRootAccess: _terminalRepo.checkRootAccess()));
    });
  }

  final String _filename = "faustus_controller.sh";
  final String _assetPath = "assets/scripts/";

  Future execute(String command) async {
    await _terminalRepo.execute(command);
  }

  Future initScript() async {
    final byteData = await rootBundle.load('$_assetPath/$_filename');
    Constants.kExecFile = "${(await Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora').create()).path}/$_filename";
    await File(Constants.kExecFile).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  void requestAccess() async {
    await initScript();
    await execute("chmod +x ${Constants.kExecFile}");
    await execute("pkexec ${Constants.kExecFile}");
  }

  void killProcess() {
    _terminalRepo.killProcess();
  }
}
