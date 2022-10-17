import 'package:aurora/user_interface/setup_wizard/data/repository/setup_wizard_source.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';

class SetupWizardRepoImpl extends SetupWizardRepo{
  SetupWizardRepoImpl(this._setupWizardSource);

  final SetupWizardSource _setupWizardSource;

  @override
  Future<String> getTerminalList()async{
    var output=await _setupWizardSource.getTerminalList();
    if(output.isEmpty) return '';
    return output.split('"\$TERMINAL" ')[1].split(';')[0];
  }

  @override
  Future<String> getAuroraLiveVersion() async{
    var output=await _setupWizardSource.getAuroraLiveVersion();
    if(output.isEmpty) return '0';
    return output.split('version: ')[1].split('+')[0];
  }

  @override
  Future<String> getChangelog() async{
    return await _setupWizardSource.getChangelog();
  }

}