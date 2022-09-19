import 'package:aurora/utility/placeholder.dart';
import 'package:flutter/cupertino.dart';

abstract class SetupWizardState{}

class SetupWizardInitState extends SetupWizardState{
  SetupWizardInitState();
}

class SetupWizardCompatibleState extends SetupWizardState{
  SetupWizardCompatibleState();
}

class SetupWizardIncompatibleState extends SetupWizardState{
  int stepValue;
  Widget? child=placeholder();
  SetupWizardIncompatibleState({required this.stepValue,this.child});
}
