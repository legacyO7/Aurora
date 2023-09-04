

import 'package:aurora/shared/data/shared_data.dart';

abstract class KeyboardSettingsRepo{
  Future setMode({required ArMode arMode});
  Future setColor({required ArMode arMode});
  Future setSpeed({required ArMode arMode});
  Future setBrightness(int brightness);
  Future setMainlineStateParams({required ArState arState});
  Future setMainlineModeParams({required ArMode arMode});
}