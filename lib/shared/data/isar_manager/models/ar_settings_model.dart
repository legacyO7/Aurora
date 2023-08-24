import 'package:isar/isar.dart';

part 'ar_settings_model.g.dart';

@collection
class ArSettingsModel {

  Id? id;

  String? arVersion;
  String? arTheme;
  bool enforceFaustus;
  int? profileId;

  ArSettingsModel({this.arVersion, this.arTheme, this.enforceFaustus=false, this.profileId});
}


