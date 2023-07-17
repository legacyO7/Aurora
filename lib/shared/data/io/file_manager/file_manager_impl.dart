import 'dart:io';

import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/shared/shared.dart';


class FileManagerImpl extends FileManager{

  FileManagerImpl(this._ioManager);

  final IOManager _ioManager;

  @override
  void setWorkingDirectory() async{
    Constants.globalConfig.setInstance(
        kWorkingDirectory: await _validateWorkingDir()
    );
  }

  Future<String> _workingDir(String path) async{
    if(await _ioManager.checkIfExists(filePath: path, fileType: FileSystemEntityType.directory)){
      return path;
    }
    stderr.writeln("invalied path $path, falling back to /tmp");
    return '/tmp';
  }

  Future<String> _validateWorkingDir() async{

    switch(Constants.buildType){

      case BuildType.debug:
        return await _workingDir('${Directory.current.path}/assets/scripts/');

      case BuildType.rpm:
      case BuildType.deb:
        return Constants.installedDir;

      case BuildType.appimage:
        return await _workingDir("${_getAppImageExtractionDir()}/data/flutter_assets/assets/scripts/");

    }
  }

  String _getAppImageExtractionDir() {
    const selfLink = Constants.selfLinker;
    final selfLinkTarget = File(selfLink).resolveSymbolicLinksSync();
    final extractionDir = Directory(selfLinkTarget).parent;
    return extractionDir.path;
  }



}