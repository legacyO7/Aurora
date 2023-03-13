import 'dart:io';

import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';
import 'package:aurora/user_interface/terminal/domain/repository/terminal_delegate.dart';
import 'package:aurora/utility/ar_widgets/snackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:path_provider/path_provider.dart';

class SetupRepoImpl extends SetupRepo{
  SetupRepoImpl(this._setupSource, this._terminalDelegate);

  final SetupSource _setupSource;
  final TerminalDelegate _terminalDelegate;

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
    Directory workingDir= Directory('${(await getTemporaryDirectory()).path}/legacy07.aurora');
    if(workingDir.existsSync()){
      workingDir.deleteSync(recursive: true);
    }
    _globalConfig
      ..setInstance(
        kWorkingDirectory: (await workingDir.create()).path,
        kSecureBootEnabled: await _terminalDelegate.isSecureBootEnabled())
      ..setInstance(
      kExecPermissionCheckerPath: await _terminalDelegate.extractAsset(sourceFileName: Constants.kPermissionChecker));
  }
  
  @override
  Future loadSetupFiles() async{
    await _terminalDelegate.extractAsset(sourceFileName: Constants.kFaustusInstaller);
    _setupPath = "${await _terminalDelegate.extractAsset(sourceFileName: Constants.kArSetup)} ${_globalConfig.kWorkingDirectory}";
    if(_globalConfig.kSecureBootEnabled! || !await _terminalDelegate.pkexecChecker()){
      _terminalList = '" ${(await getTerminalList())} "';
    }
  }
  
  @override
  Future installPackages() async{
    if (_terminalList.isNotEmpty || _pkexec) {
      await _terminalDelegate.execute("${!_pkexec ? '' : Constants.kPolkit} $_setupPath installpackages $_terminalList");
    } else {
      arSnackBar(text: "Fetching Data Failed", isPositive: false);
    }
  }

  @override
  Future<bool> pkexecChecker() async{
    _pkexec= await _terminalDelegate.pkexecChecker();
    return _pkexec;
  }


  @override
  Future installFaustus() async{
    await _terminalDelegate.execute("${_globalConfig.kSecureBootEnabled! ? '' : Constants.kPolkit} $_setupPath installfaustus ${Constants.globalConfig.kFaustusGitUrl} $_terminalList");
  }

  @override
  List<String> get missingPackagesList => _terminalDelegate.listMissingPackages.split(' ');
  
  

}