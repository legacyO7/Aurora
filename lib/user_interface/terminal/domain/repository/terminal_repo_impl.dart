import 'dart:async';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:rxdart/rxdart.dart';

import 'terminal_repo.dart';

class TerminalRepoImpl extends TerminalRepo{

  TerminalRepoImpl(this._terminalSource){
    _terminalSink = _tStreamController.sink;
    _terminalSource.terminalOutStream.listen((event) {
      _terminalOut.add(event);
      _terminalSink.add(_terminalOut);
    },onDone: ()=>disposeStream());
  }

  final _tStreamController = BehaviorSubject<List<String>>();
  late Sink<List<String>>  _terminalSink;

  final List<String> _terminalOut=[];

  final TerminalSource _terminalSource;


  @override
  Future execute(String command) async {
    return await _terminalSource.execute(command);
  }

  @override
  Future<bool> checkAccess() async{

    var permissionChecker=Constants.globalConfig.kExecPermissionCheckerPath!;
    if (Constants.globalConfig.arMode==ARMODE.batterymanager) {
      permissionChecker+=' ${Constants.kBatteryThresholdPath}';
    }
    List<String> value = await getOutput(command: permissionChecker);
    if(value.length>1) {
      return value[1].split(' ')[1].toLowerCase()=='true';
    }
    return false;
  }

  @override
  clearTerminalOut(){
    _terminalOut.clear();
  }

  @override
  void disposeStream() {
    _terminalSource.disposeStream();
    _tStreamController.close();
    _terminalSink.close();
    _terminalOut.clear();
  }

  @override
  Future<List<String>> getOutput({required String command}) async{

    _terminalOut.clear();
    await execute(command);

    return _terminalOut.sublist(_terminalOut.indexWhere((element) => element.contains(command)));

  }

  @override
  bool isInProgress() =>_terminalSource.isInProgress();

  @override
  void killProcess() {
    _terminalSource.killProcess();
  }

  @override
  Stream<List<String>> get terminalOutStream => _tStreamController.stream;
}