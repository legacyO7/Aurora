import 'package:aurora/user_interface/setup_wizard/data/source/setup_wizard_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:dio/dio.dart';

class SetupWizardSourceImpl extends SetupWizardSource{

  @override
  Future<String> getTerminalList() async{
    try {
      return (await Dio().get(Constants.kTerminalListUrl)).data.toString();
    }on Exception{
      return '';
    }
  }

}