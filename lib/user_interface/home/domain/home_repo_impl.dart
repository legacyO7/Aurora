import 'dart:io';

import 'package:aurora/user_interface/home/domain/home_mixin.dart';
import 'package:aurora/user_interface/terminal/data/source/terminal_source.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with HomeMixin{

  HomeRepoImpl(this._terminalSource);

  final TerminalSource _terminalSource;

  @override
  Future<String> extractAsset({required String sourceFileName}) async {
    final byteData = await rootBundle.load('${Constants.kAssetsPath}/$sourceFileName');
    var destinationFileName = "${Constants.kWorkingDirectory}/$sourceFileName";
    await File(destinationFileName).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    await _terminalSource.execute("chmod +x $destinationFileName");
    return destinationFileName;
  }

  @override
  List<String> readFile({required String path}){
    return (File(path).readAsLinesSync());
  }

  @override
  Future<bool> checkInternetAccess() async{
    try {
      final result = await InternetAddress.lookup('www.google.com');
        return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future launchArUrl({String? subPath}) async {
    var url = Uri.parse(Constants.kAuroraGitUrl+(subPath??''));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "error launching $url";
    }
  }

  @override
  Future<String> getVersion() async{
    return (await PackageInfo.fromPlatform()).version;
  }

  @override
  bool compatibilityChecker() => Directory(Constants.kFaustusModulePath).existsSync();

  @override
  Future<int> getBatteryCharge() async{
    return int.parse((await File(Constants.kBatteryThresholdPath).readAsString()).toString().trim());
  }

}