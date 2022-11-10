

import 'package:aurora/user_interface/home/domain/home_mixin.dart';

abstract class HomeRepo{
  Future<String> extractAsset({required String sourceFileName});
  List<String?> readFile({required String path});
  Future<bool> isSecureBootEnabled();
  Future<bool> checkInternetAccess();
  Future launchArUrl({String? subPath});
  Future<String> getVersion();
  Future<int> compatibilityChecker();
  bool systemHasSystemd();
  Future<int> getBatteryCharge();
  int convertVersionToInt(String version);
}