
import 'package:aurora/utility/ar_widgets/ar_enums.dart';

abstract class HomeRepo{
  void setAppHeight();
  Future<bool> requestAccess();
  Future<bool> canElevate();
  Future selfElevate();
  Future initLog();
  Future<bool> enforcement(Enforcement enforce);
}