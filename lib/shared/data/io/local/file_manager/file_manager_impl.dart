import 'dart:io';

import 'package:aurora/utility/ar_widgets/ar_enums.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/shared/shared.dart';
import 'package:aurora/utility/global_configuration.dart';
import 'package:aurora/utility/global_mixin.dart';


class FileManagerImpl extends FileManager with GlobalMixin{

  FileManagerImpl(this._ioManager);

  final IOManager _ioManager;

  final GlobalConfig _globalConfig=Constants.globalConfig;

  @override
  Future setWorkingDirectory() async{
    _globalConfig.setInstance(
        kWorkingDirectory: await _validateWorkingDir()
    );
  }

  Future<String> _workingDir(String path) async{
    if(await _ioManager.checkIfExists(filePath: path, fileType: FileSystemEntityType.directory)){
      return path;
    }
    stderr.writeln("invalid path $path, falling back to /tmp");
    return '/tmp';
  }

  Future<String> _validateWorkingDir() async{

      switch (Constants.buildType) {
        case BuildType.debug:
          return await _workingDir('${Directory.current.path}/assets/scripts/');

        case BuildType.rpm:
        case BuildType.deb:
          return Constants.kInstalledDir;

        case BuildType.appimage:
          return await _workingDir("${_getAppImageExtractionDir()}/data/flutter_assets/assets/scripts/");
      }

  }

  Future <Directory> _clearTmpWorkingDir() async{
    Directory workingDir= Directory('${Directory.systemTemp.path}/legacy07.aurora');
    if(await workingDir.exists()){
      await workingDir.delete(recursive: true);
    }
    return workingDir;
  }

  @override
  Future setTmpWorkingDir() async{
    _globalConfig
        .setInstance(
        kWorkingDirectory: (await (await _clearTmpWorkingDir()).create()).path);
  }

  @override
  Future releaseTmpWorkingDir() async{
    await _clearTmpWorkingDir();
    await setWorkingDirectory();
  }

  @override
  Future<List<String>> searchTextFilesInDirectory({required List<String> searchText, required String directoryPath, bool searchSubDirectories=false}) async{
    List<String> filesFound = [];

    Directory directory=Directory(directoryPath);
    if (await directory.exists()) {
      await for (FileSystemEntity entity in directory.list(recursive: searchSubDirectories)) {
        if (entity is File) {
          String fileContent = await entity.readAsString();
          if (searchText.any((element) => fileContent.contains(element))) {
            filesFound.add(entity.path);
          }
        }
      }
    }

    return filesFound;
  }


  @override
  Future replaceTextInFile(String path,{required String which, required String withWhat}) async{
    File file=File(path);
    if(await file.exists()){
      List<String> content=await _ioManager.readFile(file);
      content.map((e) {
        if(e.contains(which)){
          return e.replaceAll(which, withWhat);
        }
        return e;
      }).toList();

      await _ioManager.writeToFile(filePath: file, content: content.join('\n'));
    }

  }

  @override
  Future<bool> isDeviceCompatible() async{

    bool checkDeviceInfo({required String info}){
      return (info.toLowerCase().contains('asus'));
    }

    _globalConfig.setInstance(deviceName: ( await _ioManager.readFile(Constants.kProductName)).join(''));
    return(checkDeviceInfo(info: [...await _ioManager.readFile(Constants.kVendorName),_globalConfig.deviceName].toString()));
  }

  @override
  Future<bool> thresholdPathExists() async{
    Directory powerDir=Directory(Constants.kPowerSupplyPath);
    String? thresholdPath;
    if(powerDir.existsSync()){

      await for(var file in powerDir.list()){
        if(file.path.split('/').last.contains('BAT')){
          thresholdPath='${file.path}/charge_control_end_threshold';
          break;
        }
      }

      if(thresholdPath!=null&&File(thresholdPath).existsSync()){
        _globalConfig.setInstance(kThresholdPath: thresholdPath);
      }
    }
    return _globalConfig.kThresholdPath!=null;
  }

  String _getAppImageExtractionDir() {
    const selfLink = Constants.kSelfLinker;
    final selfLinkTarget = File(selfLink).resolveSymbolicLinksSync();
    final extractionDir = Directory(selfLinkTarget).parent;
    return extractionDir.path;
  }


}