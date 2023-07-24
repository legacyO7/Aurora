import 'package:aurora/shared/shared.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';

mixin TerminalMixin {

  final TerminalRepo _terminalRepo= sl<TerminalRepo>();

  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput("mokutil --sb-state")).toString().contains("enabled");
  }

  Future<bool> pkexecChecker() async{
    return await _terminalRepo.getOutput('type pkexec').then((value){
      if(value.isEmpty) {
        return true;
      } else{
          return !value.toString().contains('not found');
        }
    });
  }

  Future<bool> isKernelCompatible() async{
    try {
      return (int.tryParse((await _terminalRepo.getOutput('uname -r')).last
          .split('-')
          .first
          .replaceAll('.', '')) ?? 0) >= 610;
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> arServiceEnabled() async{
    return (await _terminalRepo.getOutput(Constants.kArServiceStatus))
        .toString().contains('enabled');

  }

  Future<bool> systemHasSystemd() async{
    return (await _terminalRepo.getOutput(Constants.kChecksystemd)).toString().contains('systemd');
  }

}