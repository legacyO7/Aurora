import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/user_interface/setup/data/source/dio_client.dart';
import 'package:flutter/foundation.dart';

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
    try{
      return (await _dioClient.fetch(url: Constants.kAuroraGitRawYaml)).data.toString();
    }catch(e){
      debugPrint(e.toString());
      return '';
    }
  }

  @override
  Future<String> getChangelog() async{
    try{
      return (await _dioClient.fetch(url: Constants.kAuroraGitRawChangelog)).data.toString();
    }catch(e){
      debugPrint(e.toString());
      return '';
    }
  }

}