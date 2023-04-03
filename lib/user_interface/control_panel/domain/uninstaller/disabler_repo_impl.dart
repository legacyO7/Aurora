import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';

import 'disabler_repo.dart';

class DisablerRepoImpl implements DisablerRepo{

  DisablerRepoImpl(this._terminalDelegate,this._prefRepo);

  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;

  @override
  Future disableServices({required DISABLE disable}) async{

      var command="${Constants.kPolkit} ${await _terminalDelegate.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.globalConfig.kWorkingDirectory} ";

      switch(disable) {
        case DISABLE.faustus:
            command+='disablefaustus';
            break;

        case DISABLE.all:
            command+='disablethresholdfaustus';
            break;

        case DISABLE.threshold:
            command+='disablethreshold';
            break;
        case DISABLE.none:
          // TODO: Handle this case.
          break;
      }

      await _terminalDelegate.execute(command);
      if(disable==DISABLE.all||disable==DISABLE.threshold){
        await _prefRepo.setThreshold(100);
      }

  }

}