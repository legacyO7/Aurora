import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/data/source/dio_client.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';

class SetupSourceImpl extends SetupSource{
  
  SetupSourceImpl(this._dioClient);

  final DioClient _dioClient;
  
  @override
  Future<String> getTerminalList() async{
    try {
      return (await _dioClient.fetch(url: Constants.kTerminalListUrl)).data.toString();
    }on Exception{
      return '';
    }
  }

  @override
  Future<String> getAuroraLiveVersion() async{
    try {
      return (await _dioClient.fetch(url: Constants.globalConfig.kAuroraGitRawYaml!)).data.toString();
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
      return 'version: 0.0.0-unknwon+0';
    }
  }

  @override
  Future<String> getChangelog() async{
    try{
      return (await _dioClient.fetch(url: Constants.globalConfig.kAuroraGitRawChangelog!)).data.toString();
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
      return 'unable to get changelog';
    }
  }

}