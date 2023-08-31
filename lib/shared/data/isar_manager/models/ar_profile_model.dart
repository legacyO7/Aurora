
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'ar_profile_model.g.dart';


@Collection(inheritance: false)
//ignore: must_be_immutable
class ArProfileModel extends Equatable{
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

  factory ArProfileModel.copyModel(ArProfileModel model){
    return ArProfileModel(
        id: model.id,
        profileName: model.profileName,
        threshold: model.threshold,
        brightness: model.brightness,
        arState: model.arState,
        arMode: model.arMode);
  }


  bool matches(ArProfileModel other){
    return
      threshold==other.threshold &&
      brightness==other.brightness &&
      arState==other.arState &&
      arMode==other.arMode;
  }

  @override
  @ignore
  List<Object?> get props => [profileName, threshold, brightness, arState, arMode];

  @ignore
  List<Object?> get propsWithoutProfileName => [ threshold, brightness, arState, arMode];
}