import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_repo.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TerminalRepo _terminalRepo;
  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  HomeCubit(this._terminalRepo,this._prefRepo,this._homeRepo) : super(HomeStateInit());

  Future getVersion() async{
    Constants.arVersion= (await PackageInfo.fromPlatform()).version;
  }

  Future execute(String command) async {
    await _terminalRepo.execute(command);
  }


  Future requestAccess() async {

    await getVersion();
    Constants.kExecBatteryManagerPath=await _homeRepo.extractAsset(sourceFileName:Constants.kBatteryManager);
    Constants.kExecFaustusPath=await _homeRepo.extractAsset(sourceFileName:Constants.kFaustus);


    var checkAccess=await _terminalRepo.checkAccess();
    if(!checkAccess) {
      await execute("${Constants.kPolkit} ${Constants.kExecFaustusPath} init ${Constants.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
    }
    emit(AccessGranted(hasAccess: checkAccess));

  }


  void dispose(){
    emit(HomeStateInit());
  }

}
