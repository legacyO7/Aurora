import 'package:aurora/data/model/ar_mode_model.dart';

abstract class KeyboardSettingsRepo{
  Future setMode({required ArMode arMode});
  Future setColor({required ArMode arMode});
  Future setSpeed({required ArMode arMode});
  Future setBrightness(int brightness);
  Future setMainlineStateParams({required int boot, required int awake, required int sleep});
  Future setMainlineModeParams({required ArMode arMode});
}