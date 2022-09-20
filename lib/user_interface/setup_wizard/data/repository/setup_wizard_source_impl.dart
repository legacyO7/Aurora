import 'package:aurora/user_interface/setup_wizard/data/source/setup_wizard_source.dart';
import 'package:dio/dio.dart';

class SetupWizardSourceImpl extends SetupWizardSource{

  @override
  Future<String> getTerminalList() async{
    try {
      return (await Dio().get('https://raw.githubusercontent.com/i3/i3/next/i3-sensible-terminal')).data.toString();
    }on Exception{
      return '';
    }
  }

}