import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';
import 'package:rxdart/rxdart.dart';

import 'terminal_source.dart';

class TerminalSourceImpl extends TerminalSource{

  TerminalSourceImpl();

  late Process process;
  bool _inProgress=false;

  final Completer<int> completer = Completer<int>();
  final LineSplitter _lineSplitter=const LineSplitter();
  final _tStreamController = BehaviorSubject<String>();
  late Sink<String>  _terminalSink;

  final List<String> _commands=[];
  List<String> _perCommandOutput=[];


  @override
  Future execute(String command) async{
    _commands.add(command.trim());
    if(!_inProgress){
      await _execute(_commands.first);
    }
  }


  Future _execute(String command) async {

    _terminalSink = _tStreamController.sink;

    if(command.isNotEmpty) {

        _convertToList(lines: "\$ $command", commandStatus: CommandStatus.stdinp);

        try {
          _inProgress = true;
          _perCommandOutput=[];

          process = await Process.start(
              'bash',
              ['-c', command],
              workingDirectory: Constants.globalConfig.kWorkingDirectory,
              runInShell: true,
              mode: ProcessStartMode.detachedWithStdio
          );

          getStdout();
          await getStdErr();

        } catch(e,stackTrace) {
          await ArLogger.log(data: e,stackTrace: stackTrace);
          _inProgress = false;
        }

      _commands.removeAt(0);
      if(_commands.isNotEmpty){
        await _execute(_commands.first);
      }else {
        _inProgress=false;
      }
    }
  }

  getStdout() async{
    process.stdout.transform(utf8.decoder).listen((data) {
      _convertToList(lines: data ,commandStatus: CommandStatus.stdout);
    });
  }

  getStdErr() async{
    await for (var line in process.stderr) {
      _convertToList(lines: utf8.decode(line),commandStatus: CommandStatus.stderr);
    }
  }

  _convertToList({required String lines, required CommandStatus commandStatus}){

    for ( var line in  _lineSplitter.convert(lines)){
      _perCommandOutput.add(line);
      _terminalSink.add("${commandStatus.name} $line");
       ArLogger.log(data: "> ${commandStatus.name} $line");
    }
  }

  @override
  Future<List<String>> getOutput(String command) async{
    await execute(command);
    return _perCommandOutput;
  }


  @override
  killProcess(){
    try {
      if(_inProgress) {
        process.kill();
      }
    }catch(e,stackTrace){
      _convertToList(lines: e.toString(),commandStatus: CommandStatus.stderr);
      ArLogger.log(data: e,stackTrace: stackTrace);
    }
    finally{
      _convertToList(lines: "process terminated",commandStatus: CommandStatus.stderr);
      _inProgress=false;
    }
  }

  @override
  bool isInProgress()=> _inProgress;

  @override
  Stream<String> get terminalOutStream => _tStreamController.stream;

  @override
  void disposeStream(){
    _tStreamController.close();
    _terminalSink.close();
  }

}