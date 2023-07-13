import 'package:aurora/utility/ar_widgets/ar_enums.dart';

abstract class DisablerRepo{
  Future<bool> disableServices({required DISABLE disable});
}