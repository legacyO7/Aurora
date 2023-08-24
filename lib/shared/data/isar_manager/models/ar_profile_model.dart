
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:isar/isar.dart';

part 'ar_profile_model.g.dart';


@collection
class ArProfileModel{
  Id? id;
  String profileName;
  int threshold;
  int brightness;
  ArState arState;
  ArMode arMode;

  ArProfileModel({
    this.id,
    required this.profileName,
    required this.threshold,
    required this.brightness,
    required this.arState,
    required this.arMode
  });
}