import 'dart:async';


import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:rxdart/rxdart.dart';


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
  Future<List<String>> getOutput(String command) async{
    return await  _terminalSource.getOutput(command);
  }

  @override
  Future<int> getStatusCode(String command) async{
    try {
      List<String> output = await _terminalSource.getOutput('$command; echo \$?');
      return int.tryParse(output.last.trim())??-1;
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
      return -1;
    }

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