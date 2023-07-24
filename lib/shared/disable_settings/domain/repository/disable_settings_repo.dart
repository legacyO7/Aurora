import 'package:aurora/utility/ar_widgets/ar_enums.dart';

abstract class DisableSettingsRepo{
  Future<bool> disableServices({required DisableEnum disable});
}