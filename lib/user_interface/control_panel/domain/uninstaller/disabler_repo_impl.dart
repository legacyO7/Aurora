import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/data/io/permission_manager/permission_manager.dart';
import 'package:aurora/data/io/service_manager/service_manager.dart';
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';

import 'disabler_repo.dart';

class DisablerRepoImpl implements DisablerRepo{

  DisablerRepoImpl(this._terminalDelegate,this._prefRepo,this._serviceManager,this._permissionManager,this._ioManager);

  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;

  final IOManager _ioManager;
  final PermissionManager _permissionManager;
  final ServiceManager _serviceManager;

  @override
  Future disableServices({required DISABLE disable}) async{
    
      switch(disable) {
        case DISABLE.faustus:
            await _disableFaustus();
            break;

        case DISABLE.all:
            await _disableFaustus();
            await _disableBatteryManager();
            break;

        case DISABLE.threshold:
            await _disableBatteryManager();
            break;

        case DISABLE.uninstall:
            await _disableFaustus(uninstall: true);
            break;
        case DISABLE.none:
          // TODO: Handle this case.
          break;
      }
      
      if(disable==DISABLE.all||disable==DISABLE.threshold){
        await _prefRepo.setThreshold(100);
      }

      if(disable==DISABLE.uninstall){
        await _prefRepo.nukePref();
      }

  }
  
  Future _disableFaustus({bool uninstall = false}) async{
    var command="${Constants.kPolkit} ${await _terminalDelegate.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.globalConfig.kWorkingDirectory} ${uninstall?'uninstall':'disablefaustus'}";
    await _terminalDelegate.execute(command);
  }
  
  Future _disableBatteryManager() async{

    await _permissionManager.runWithPrivileges(["systemctl disable ${Constants.kServiceName}"]);
    await _ioManager.writeToFile(
        filePath: Constants.globalConfig.kThresholdPath!,
        content: '100'
    );
    await _serviceManager.deleteService();
  }

}