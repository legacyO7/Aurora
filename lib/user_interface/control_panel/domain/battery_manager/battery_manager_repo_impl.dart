import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/data/io/permission_manager/permission_manager.dart';
import 'package:aurora/data/io/service_manager/service_manager.dart';
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/constants.dart';

import 'battery_manager_repo.dart';

class BatteryManagerRepoImpl implements BatteryManagerRepo{

  BatteryManagerRepoImpl(this._terminalDelegate, this._prefRepo, this._ioManager,this._permissionManager,this._serviceManager);


  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;
  final IOManager _ioManager;
  final PermissionManager _permissionManager;
  final ServiceManager _serviceManager;

  @override
  Future initBatteryManager() async{
    await setBatteryChargeLimit(limit: (await _prefRepo.getThreshold())??await getBatteryCharge());
  }

  @override
  Future<int> getBatteryCharge() async{
    if(Constants.globalConfig.kThresholdPath!=null) {
      return int.parse((await _ioManager.readFile(Constants.globalConfig.kThresholdPath!)).first.toString().trim());
    }
    return Constants.kMinimumChargeLevel;
  }

  @override
  Future setBatteryChargeLimit({required int limit}) async{
    if(!await _terminalDelegate.arServiceEnabled()){
      await _permissionManager.setPermissions();
    }
    await _prefRepo.setThreshold(limit);
    await _ioManager.writeToFile(
        filePath: Constants.globalConfig.kThresholdPath!,
        content: '$limit'
    );
    await _serviceManager.updateService();
  }

}