import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/constants.dart';

import 'battery_manager_repo.dart';

class BatteryManagerRepoImpl implements BatteryManagerRepo{

  BatteryManagerRepoImpl(this._terminalDelegate, this._prefRepo);


  final TerminalDelegate _terminalDelegate;
  final PrefRepo _prefRepo;

  @override
  Future initBatteryManager() async{
    await setBatteryChargeLimit(limit: (await _prefRepo.getThreshold())??await getBatteryCharge());
  }

  @override
  Future<int> getBatteryCharge() async{
    if(Constants.globalConfig.kThresholdPath!=null) {
      return int.parse((await File(Constants.globalConfig.kThresholdPath!).readAsString()).toString().trim());
    }
    return Constants.kMinimumChargeLevel;
  }

  @override
  Future setBatteryChargeLimit({required int limit}) async{
    if(await arServiceEnabled()) {
      await _terminalDelegate.execute("${Constants.globalConfig.kExecBatteryManagerPath} $limit");
    }else{
      await _terminalDelegate.execute("${Constants.kPolkit} ${Constants.globalConfig.kExecBatteryManagerPath} $limit");
    }
    await _prefRepo.setThreshold(limit);
  }

  Future<bool> arServiceEnabled() async{
    return (await _terminalDelegate.getOutput(command: Constants.kArServiceStatus))
        .toString().contains('aurora-controller.service; enabled');

  }

}