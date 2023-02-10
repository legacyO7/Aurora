import 'dart:io';

import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';

import 'battery_manager_repo.dart';

class BatteryManagerRepoImpl implements BatteryManagerRepo{

  BatteryManagerRepoImpl(this._terminalSource, this._prefRepo);


  final TerminalSource _terminalSource;
  final PrefRepo _prefRepo;

  @override
  Future<int> getBatteryCharge() async{
    return int.parse((await File(Constants.kBatteryThresholdPath).readAsString()).toString().trim());
  }

  @override
  Future setBatteryChargeLimit({required int limit, required bool serviceEnabled}) async{
    if(serviceEnabled) {
      await _terminalSource.execute("${Constants.globalConfig.kExecBatteryManagerPath} $limit");
    }else{
      await _terminalSource.execute("${Constants.kPolkit} ${Constants.globalConfig.kExecBatteryManagerPath} $limit");
    }
    await _prefRepo.setThreshold(limit);
  }

}