import 'package:aurora/user_interface/control_panel/presentation/state/disabler/disabler_bloc.dart';

abstract class DisablerRepo{
  Future disableServices({required DISABLE disable});
}