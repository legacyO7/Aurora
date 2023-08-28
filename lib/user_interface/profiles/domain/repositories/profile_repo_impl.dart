import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:aurora/user_interface/profiles/domain/models/profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo{

  ProfileRepoImpl(this._isarManager);

  final IsarManager _isarManager;

  @override
  Future<List<ProfileModel>> getAllProfiles()  async{
   return (await _isarManager.readAllArProfileIsar()).map((e) =>
       ProfileModel(id: e.id!, profileName: e.profileName)).toList();
  }

  @override
  Future<ArProfileModel> getCurrentProfile() async{
    return (await _isarManager.readArProfileIsar())!;
  }

  @override
  Future<ArProfileModel> loadProfile(int id) async{
    return (await _isarManager.readArProfileIsar(id:id))!;
  }

  @override
  Future setProfile({required ArProfileModel arProfileModel}) async{
    await _isarManager.writeArProfileIsar(arProfileModel: arProfileModel);
  }

  @override
  Future deleteProfile({required int id}) async{
    await _isarManager.deleteArProfileIsar(id: id);
    await _isarManager.readArProfileIsar(id: (await getAllProfiles()).last.id);
  }


}