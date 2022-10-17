import 'package:aurora/user_interface/setup_wizard/data/repository/setup_wizard_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/user_interface/setup_wizard/data/source/dio_client.dart';
import 'package:flutter/foundation.dart';

class SetupWizardSourceImpl extends SetupWizardSource{
  
  SetupWizardSourceImpl(this._dioClient);

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