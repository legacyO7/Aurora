import 'package:aurora/shared/shared.dart';

import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';

class SetupRepoImpl extends SetupRepo with GlobalMixin, TerminalMixin{
  SetupRepoImpl(this._setupSource,this._terminalRepo,this._permissionManager,this._fileManager);

  final SetupSource _setupSource;
  final TerminalRepo _terminalRepo;
  final PermissionManager _permissionManager;
  final FileManager _fileManager;

  final _globalConfig=Constants.globalConfig;
  String _setupPath='';
  String _terminalList = '';
  bool _pkexec=false;


  @override
  Future<String> getTerminalList()async{
    var output=await _setupSource.getTerminalList();
    if(output.isEmpty) return '';
    return output.split('"\$TERMINAL" ')[1].split(';')[0];
  }

  @override
  Future<String> getAuroraLiveVersion() async{
    var output=await _setupSource.getAuroraLiveVersion();
    if(output.isEmpty) return '0';
    return output.split('version: ')[1].split('+')[0];
  }

  @override
  Future<String> getChangelog() async{
    return await _setupSource.getChangelog();
  }
  
  @override
  Future initSetup() async{
    try {
      _fileManager.setWorkingDirectory();
      if (!isMainLineCompatible()) {
        _globalConfig.setInstance(
            kSecureBootEnabled: await super.isSecureBootEnabled()
        );
      }
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
    }
  }
  
  @override
  Future loadSetupFiles() async{
    _setupPath = "${_globalConfig.kWorkingDirectory!+Constants.kArSetup} ${_globalConfig.kWorkingDirectory}";
    if(_globalConfig.kSecureBootEnabled! || !await super.pkexecChecker()){
      _terminalList = '" ${(await getTerminalList())} "';
    }
  }
  
  @override
  Future installPackages() async{
    if (_terminalList.isNotEmpty || _pkexec) {
      await _terminalRepo.execute("${!_pkexec ? '' : Constants.kPolkit} $_setupPath installpackages $_terminalList");
    } else {
      arSnackBar(text: "Fetching Data Failed", isPositive: false);
    }
  }

  @override
  Future<bool> pkexecChecker() async{
    _pkexec= await super.pkexecChecker();
    return _pkexec;
  }


  @override
  Future installFaustus() async{
    await _terminalRepo.execute("${_globalConfig.kSecureBootEnabled! ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.globalConfig.kFaustusGitUrl} $_terminalList");
  }

  @override
  List<String> get missingPackagesList => _permissionManager.listMissingPackages;
  

}