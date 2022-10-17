import 'package:aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:aurora/user_interface/setup/domain/repository/setup_repo.dart';

class SetupRepoImpl extends SetupRepo{
  SetupRepoImpl(this._setupSource);

  final SetupSource _setupSource;

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

}