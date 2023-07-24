
import 'package:aurora/utility/ar_widgets/ar_enums.dart';

abstract class HomeRepo{
  Future launchArUrl({String? subPath});
  void setAppHeight();
  Future<bool> requestAccess();
  Future<bool> canElevate();
  Future selfElevate();
  Future writeToFile({required String path, required String content});
  Future initLog();
  Future<bool> enforcement(Enforcement enforce);
}