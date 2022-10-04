import 'dart:async';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';
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
  bool _hasRootAccess=false;

  final TerminalSource _terminalSource;


  @override
  Future execute(String command) async {
    return await _terminalSource.execute(command);
  }

  @override
  Future<bool> checkAccess() async{
    _hasRootAccess=false;
    await getOutput(command: "${Constants.kExecFaustusPath} save").then((value) {
      for (int i =0;i<value.length;i++) {
        if(value[i].contains('faustus_controller.sh save')&&i+1<value.length){
          _hasRootAccess=!value[i+1].contains('Permission denied');
        }
      }
    });

    return _hasRootAccess;
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