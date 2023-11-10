
import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:aurora/utility/constants.dart';


class DisableSettingsRepoImpl extends DisableSettingsRepo with TerminalMixin {

  DisableSettingsRepoImpl(this._isarDelegate,this._serviceManager,this._permissionManager,this._ioManager);

  final IsarDelegate _isarDelegate;

  final IOManager _ioManager;
  final PermissionManager _permissionManager;
  final ServiceManager _serviceManager;


  @override
  Future<bool> disableServices({required DisableEnum disable}) async{

    List<String> disableCommands=[];

    List<String> disableMainlineCommandList=[
      'modprobe -r asus_wmi',
      'modprobe -r asus_nb_wmi',
      'printf "blacklist asus_wmi\\n blacklist asus_nb_wmi\\n" | sudo tee /etc/modprobe.d/faustus.conf',
      'modprobe faustus || echo faustus aint available'
    ];

    List<String> disableFaustusCommandList=[
      'rmmod faustus',
      'printf "blacklist faustus\\n" | sudo tee /etc/modprobe.d/faustus.conf',
      'modprobe asus-nb-wmi',
      'modprobe asus-wmi',
      'dkms remove faustus/0.2 --all || echo faustus aint available'
    ];

    List<String> uninstallAuroraCommandList=[
      'sudo rm -rf /opt/aurora',
      'sudo rm -rf /usr/bin/aurora',
      'sudo rm -rf /usr/local/lib/Aurora',
      'sudo rm -f /usr/share/applications/aurora.desktop'
    ];


      switch(disable) {
        case DisableEnum.mainline:
            disableCommands.addAll(disableMainlineCommandList);
            break;

        case DisableEnum.faustus:
            disableCommands.addAll(disableFaustusCommandList);
            break;

        case DisableEnum.all:
            disableCommands.addAll([
              ...disableFaustusCommandList,
              "systemctl disable ${Constants.kServiceName}"
            ]);
            break;

        case DisableEnum.threshold:
            disableCommands.add("systemctl disable ${Constants.kServiceName}");
            break;

        case DisableEnum.uninstall:
            disableCommands.addAll([...disableFaustusCommandList,...uninstallAuroraCommandList]);
            break;
        case DisableEnum.none:
          // TODO: Handle this case.
          break;
      }

      bool isSuccess= await _runDisableCommand(disableCommands);

      if(!await super.arServiceEnabled()) {
        if (disable == DisableEnum.all || disable == DisableEnum.threshold) {
          await _disableBatteryManager();
          await _isarDelegate.setThreshold(100);
        }
      }

        if (disable == DisableEnum.uninstall) {
          await _isarDelegate.deleteDatabase();
        }

        if(!isSuccess) {
          arSnackBar(text: "Failed to apply setting",isPositive: false);
        }

        return isSuccess;
  }

  Future<bool> _runDisableCommand(List<String> commands) async{
    return (await _permissionManager.runWithPrivileges(commands))==0;
  }
  

  Future _disableBatteryManager() async{
    await _ioManager.writeToFile(
        filePath: Constants.globalConfig.kThresholdPath!,
        content: '100'
    );
    await _serviceManager.deleteService();
  }

}