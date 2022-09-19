import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'setup_wizard_state.dart';

class SetupWizardCubit extends Cubit<SetupWizardState>{
  SetupWizardCubit():super(SetupWizardInit());

  bool compatibilityChecker() => Directory('/sys/devices/platform/faustus/').existsSync();



}