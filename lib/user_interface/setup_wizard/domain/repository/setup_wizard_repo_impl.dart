import 'package:aurora/user_interface/setup_wizard/data/source/setup_wizard_source.dart';
import 'package:aurora/user_interface/setup_wizard/domain/repository/setup_wizard_repo.dart';

class SetupWizardRepoImpl extends SetupWizardRepo{
  SetupWizardRepoImpl(this._setupWizardSource);

  final SetupWizardSource _setupWizardSource;

  @override
  Future<String> getTerminalList()async{
    var output=await _setupWizardSource.getTerminalList();
    if(output.isEmpty) return '';
    return (await _setupWizardSource.getTerminalList()).split('"\$TERMINAL" ')[1].split(';')[0];
  }


}