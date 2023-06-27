import 'dart:async';

import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
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
    GlobalConfig globalConfig=Constants.globalConfig;

    List<String> pathList=[];
    if(globalConfig.arMode.name.contains(ARMODE.mainline.name)){
      pathList.addAll([
        Constants.kMainlineModuleStatePath,
        Constants.kMainlineModuleModePath,
        Constants.kMainlineBrightnessPath
      ]);

      if(globalConfig.kThresholdPath!=null){
        pathList.add(globalConfig.kThresholdPath!);
      }

    }

    if (globalConfig.arMode==ARMODE.batteryManager&&globalConfig.kThresholdPath!=null) {
      pathList.add(globalConfig.kThresholdPath!);
    }


    checkPermission({String path=''})async {
      path=' $path';
      List<String> value = await getOutput(command: "$permissionChecker$path".trim());
      if(value.isNotEmpty) {
        return value.contains('true');
      }
      return false;
    }

    if(pathList.isEmpty){
     return await checkPermission();
    }else{
      for( var element in pathList){
        if(!await checkPermission(path: element)) {
          return false;
        }
      }
      return true;
    }


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

    await execute(command);

    return _terminalOut.length>1? (_terminalOut.sublist(_terminalOut.lastIndexWhere((element) => element.contains(command)))
      .map((e) => e.split(' ').sublist(1).join(' ')).toList()..removeAt(0)):[];

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