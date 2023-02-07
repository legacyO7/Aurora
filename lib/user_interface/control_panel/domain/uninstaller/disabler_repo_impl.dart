import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';

import 'disabler_repo.dart';

class DisablerRepoImpl implements DisablerRepo{

  DisablerRepoImpl(this._terminalSource,this._homeRepo,this._prefRepo);

  final TerminalSource _terminalSource;
  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  @override
  Future disableServices({required DISABLE disable}) async{

      var command="${Constants.kPolkit} ${await _homeRepo.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.globalConfig.kWorkingDirectory} ";

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

      await _terminalSource.execute(command);
      if(disable==DISABLE.all||disable==DISABLE.threshold){
        await _prefRepo.setThreshold(100);
      }

  }

}