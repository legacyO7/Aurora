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

  Future<String> getFaustusDisableCommand() async=> "${Constants.kPolkit} ${await _terminalDelegate.extractAsset(sourceFileName: Constants.kArSetup)} ${Constants.globalConfig.kWorkingDirectory} ";


  @override
  Future disableServices({required DISABLE disable}) async{

    List<String> disableCommands=[];

      switch(disable) {
        case DISABLE.faustus:
            disableCommands.add("${await getFaustusDisableCommand()}disablefaustus");
            break;

        case DISABLE.all:
            disableCommands.addAll([
              "${await getFaustusDisableCommand()}disablefaustus",
              "systemctl disable ${Constants.kServiceName}"
            ]);
            break;

        case DISABLE.threshold:
            disableCommands.add("systemctl disable ${Constants.kServiceName}");
            break;

        case DISABLE.uninstall:
            disableCommands.add("${await getFaustusDisableCommand()}uninstall");
            break;
        case DISABLE.none:
          // TODO: Handle this case.
          break;
      }

      await _runDisableCommand(disableCommands);

      if(!await _terminalDelegate.arServiceEnabled()) {
        if (disable == DISABLE.all || disable == DISABLE.threshold) {
          await _disableBatteryManager();
          await _prefRepo.setThreshold(100);
        }
      }

        if (disable == DISABLE.uninstall) {
          await _prefRepo.nukePref();
        }

  }

  Future _runDisableCommand(List<String> commands) async{
    await _permissionManager.runWithPrivileges(commands);
  }
  

  Future _disableBatteryManager() async{
    await _ioManager.writeToFile(
        filePath: Constants.globalConfig.kThresholdPath!,
        content: '100'
    );
    await _serviceManager.deleteService();
  }

}