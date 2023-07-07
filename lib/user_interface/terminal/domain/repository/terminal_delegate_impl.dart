import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';

class TerminalDelegateImpl implements TerminalDelegate {

  TerminalDelegateImpl(this._terminalSource,this._terminalRepo);

  final TerminalSource _terminalSource;
  final TerminalRepo _terminalRepo;


  @override
  Future execute(String command) async {
    return await _terminalSource.execute(command);
  }

  @override
  Future<List<String>> getOutput({required String command}) async{
    return await _terminalRepo.getOutput(command: command);
  }

  @override
  Future<int> getStatusCode(String command) async{
    return await _terminalRepo.getStatusCode(command: command);
  }

  @override
  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput(command: "mokutil --sb-state")).toString().contains("enabled");
  }

  @override
  Future<bool> pkexecChecker() async{
    return await _terminalRepo.getOutput(command: 'type pkexec').then((value){
      if(value.isEmpty) {
        return true;
      } else{
          return !value.toString().contains('not found');
        }
    });
  }


  @override
  Future<bool> isKernelCompatible() async{
    try {
      return (int.tryParse((await _terminalRepo.getOutput(command: 'uname -r')).last
          .split('-')
          .first
          .replaceAll('.', '')) ?? 0) >= 610;
    }catch(_){
      return false;
    }
  }

  @override
  Future<bool> arServiceEnabled() async{
    return (await _terminalRepo.getOutput(command: Constants.kArServiceStatus))
        .toString().contains('aurora-controller.service; enabled');

  }

}