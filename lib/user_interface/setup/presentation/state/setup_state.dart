import 'package:flutter/cupertino.dart';

abstract class SetupState{}

class SetupInitState extends SetupState{
  SetupInitState();
}

class SetupConnectedState extends SetupState{
  SetupConnectedState();
}

class SetupUpdateAvailableState extends SetupState{
  String changelog;
  SetupUpdateAvailableState(this.changelog);
}

class SetupWhatsNewState extends SetupState{
  String changelog;
  SetupWhatsNewState(this.changelog);
}

class SetupCompatibleState extends SetupState{
  SetupCompatibleState();
}

class SetupMainlineCompatibleState extends SetupState{
  SetupMainlineCompatibleState();
}

class SetupDisableFaustusState extends SetupState{
  SetupDisableFaustusState();
}

class SetupCompatibleKernel extends SetupState{
  SetupCompatibleKernel();
}

class SetupBatteryManagerCompatibleState extends SetupState{
  SetupBatteryManagerCompatibleState();
}

class SetupLoadingState extends SetupState{
  SetupLoadingState();
}

class SetupPermissionState extends SetupState{
  SetupPermissionState();
}

class SetupAskNetworkAccessState extends SetupState{
  SetupAskNetworkAccessState();
}

class SetupIncompatibleState extends SetupState{
  final int stepValue;
  final Widget? child;
  final bool isValid;

  SetupIncompatibleState({
    this.stepValue=0,
    this.child,
    this.isValid=false
  });

  SetupIncompatibleState copyState({
    int? stepValue,
    Widget? child,
    bool? isValid,
  }){
    return SetupIncompatibleState(
      stepValue: stepValue??this.stepValue,
      isValid: isValid??this.isValid,
      child: child??this.child
    );
  }

}
