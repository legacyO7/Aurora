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
  Future<bool> disableServices({required DISABLE disable}) async{

    List<String> disableCommands=[];
    List<String> disableFaustusCommandList=[
      'modprobe -r faustus',
      'printf "blacklist faustus\\n" | sudo tee /etc/modprobe.d/faustus.conf',
      'sudo modprobe asus-nb-wmi',
      'sudo modprobe asus-wmi',
      'sudo dkms remove faustus/0.2 --all'
    ];

    List<String> uninstallAuroraCommandList=[
      'sudo rm -rf /opt/aurora',
      'sudo rm -rf /usr/bin/aurora',
      'sudo rm -rf /usr/local/lib/Aurora',
      'sudo rm -f /usr/share/applications/aurora.desktop'
    ];


      switch(disable) {
        case DISABLE.faustus:
            disableCommands.addAll(disableFaustusCommandList);
            break;

        case DISABLE.all:
            disableCommands.addAll([
              ...disableFaustusCommandList,
              "systemctl disable ${Constants.kServiceName}"
            ]);
            break;

        case DISABLE.threshold:
            disableCommands.add("systemctl disable ${Constants.kServiceName}");
            break;

        case DISABLE.uninstall:
            disableCommands.addAll([...disableFaustusCommandList,...uninstallAuroraCommandList]);
            break;
        case DISABLE.none:
          // TODO: Handle this case.
          break;
      }

      bool isSuccess= await _runDisableCommand(disableCommands);

      if(!await _terminalDelegate.arServiceEnabled()) {
        if (disable == DISABLE.all || disable == DISABLE.threshold) {
          await _disableBatteryManager();
          await _prefRepo.setThreshold(100);
        }
      }

        if (disable == DISABLE.uninstall) {
          await _prefRepo.nukePref();
        }

        return isSuccess;
  }

  Future<bool> _runDisableCommand(List<String> commands) async{
    return await _permissionManager.runWithPrivileges(commands)==0;
  }
  

  Future _disableBatteryManager() async{
    await _ioManager.writeToFile(
        filePath: Constants.globalConfig.kThresholdPath!,
        content: '100'
    );
    await _serviceManager.deleteService();
  }

}