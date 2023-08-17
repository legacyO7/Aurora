
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/terminal/shared_terminal.dart';
import 'package:aurora/utility/constants.dart';

import 'battery_manager_repo.dart';

class BatteryManagerRepoImpl extends BatteryManagerRepo with TerminalMixin{

  BatteryManagerRepoImpl( this._prefRepo, this._ioManager,this._permissionManager,this._serviceManager);


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
    if(!await super.arServiceEnabled()){
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