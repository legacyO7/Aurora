
import 'dart:convert';

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


  factory ArProfileModel.fromJson(Map<String, dynamic> json){

    Map<String, dynamic> convertToJson(String string)=>
        jsonDecode(string.replaceAll('\\', ''));

    return ArProfileModel(
        profileName: 'Default Profile',
        threshold: json['flutter.ar_charge_threshold'],
        brightness: json['flutter.ar_brightness'],
        arState: ArState.fromJson(convertToJson(json['flutter.ar_state'])),
        arMode: ArMode.fromJson(convertToJson(json['flutter.ar_mode']))
    );
  }


  @override
  @ignore
  List<Object?> get props => [ threshold, brightness, arState, arMode];

}