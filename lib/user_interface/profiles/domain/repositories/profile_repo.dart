import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/models/profile_model.dart';

abstract class ProfileRepo{
  Future<List<ProfileModel>> getAllProfiles();
  Future<ArProfileModel> getCurrentProfile();
  Future setProfile({required ArProfileModel arProfileModel});
}