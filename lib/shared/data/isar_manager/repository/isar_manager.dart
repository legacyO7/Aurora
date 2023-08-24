import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/models/ar_settings_model.dart';

abstract class IsarManager{
  Future initIsar();

  Future writeArSettingsIsar();
  Future updateArSettingsIsar(ArSettingsModel arSettingsModel);
  Future<ArSettingsModel?> readArSettingsIsar();
  Future deleteArSettingsIsar(int id);

  Future writeArProfileIsar(ArProfileModel arProfileModel);
  Future updateArProfileIsar(ArProfileModel arProfileModel, int id);
  Future<ArProfileModel?> readArProfileIsar(int id);
  Future deleteArProfileIsar(int id);

  ArSettingsModel get arSettingsModel;
  Future deleteDatabase();
}