import 'package:isar/isar.dart';

part 'ar_settings_model.g.dart';

@collection
class ArSettingsModel {
  Id? id;

  String? arVersion;
  String? arTheme;
  bool enforceFaustus;
  int? profileId;
  bool isBatteryManagerEnabled;
  bool isBacklightControllerAvailableEnabled;

  ArSettingsModel({
    this.arVersion,
    this.arTheme,
    this.enforceFaustus = false,
    this.profileId,
    this.isBatteryManagerEnabled=false,
    this.isBacklightControllerAvailableEnabled=false
  });

  factory ArSettingsModel.fromJson(Map<String, dynamic> json) {
    return ArSettingsModel(
        arTheme: json['flutter.system'], arVersion: json['flutter.ar_version'], enforceFaustus: json['flutter.enforce_faustus']);
  }

  @override
  toString() => "arVersion: $arVersion, arTheme: $arTheme, enforceFaustus: $enforceFaustus ";
}
