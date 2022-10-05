import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/user_interface/home/domain/home_repo.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_cubit.dart';
import 'package:aurora/utility/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'home_state.dart';

class HomeCubit extends TerminalBaseCubit<HomeState> {
  final HomeRepo _homeRepo;
  final PrefRepo _prefRepo;

  HomeCubit(this._prefRepo, this._homeRepo) : super(HomeStateInit());

  Future getVersion() async{
    Constants.arVersion= (await PackageInfo.fromPlatform()).version;
  }

  Future requestAccess() async {

    await getVersion();
    Constants.kExecBatteryManagerPath=await _homeRepo.extractAsset(sourceFileName:Constants.kBatteryManager);
    Constants.kExecFaustusPath=await _homeRepo.extractAsset(sourceFileName:Constants.kFaustus);

    var checkAccess=await super.checkAccess();
    if(!checkAccess) {
      await super.execute("${Constants.kPolkit} ${Constants.kExecFaustusPath} init ${Constants.kWorkingDirectory} ${await _prefRepo.getThreshold()}");
      checkAccess=await super.checkAccess();
    }
    emit(AccessGranted(hasAccess: checkAccess));

  }

  void launchUrl({String? subPath}){
    _homeRepo.launchArUrl(subPath: subPath);
  }

  void dispose(){
    emit(HomeStateInit());
  }

}
