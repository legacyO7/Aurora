import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/models/profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/repositories/profile_repo.dart';
import 'package:bloc/bloc.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc(this._profileRepo) : super(ProfilesState.init()) {
    on<ProfilesInitEvent>((_, emit)=>_onInit(emit));
    on<ProfilesSaveEvent>((event, emit)=>_saveProfile(emit,name: event.name));
    on<ProfilesLoadEvent>((event, emit)=>_loadProfile(emit, event.id));
    on<ProfilesDeleteEvent>((event, emit)=>_deleteProfile(emit,id: event.id));
  }

  late ArProfileModel _currentProfile;
  late List<ProfileModel> _allProfiles;

  final ProfileRepo _profileRepo;


  Future _onInit(emit) async{
    await _getCurrentProfile();
    await _getAllProfiles();

    emit(ProfilesState.loaded(
        allProfiles: _allProfiles,
        currentProfile:  _currentProfile
    ));
  }

  Future<ArProfileModel> _getCurrentProfile() async{
    _currentProfile= await _profileRepo.getCurrentProfile();
    return _currentProfile;
  }

  Future<List<ProfileModel>> _getAllProfiles() async{
    _allProfiles= await _profileRepo.getAllProfiles();
    return _allProfiles;
  }

  Future _saveProfile(emit, {required String name}) async{
    await _wrapLoader(emit, fn: () async{
      _currentProfile.profileName=name;
      if(_currentProfile.id==2) {
        _currentProfile.id = null;
      }
      await _profileRepo.setProfile(arProfileModel: _currentProfile);
      await _getCurrentProfile();
    });
  }

  Future _loadProfile(emit,int id) async{
    await _wrapLoader(emit, fn: ()async{
      _currentProfile= await _profileRepo.loadProfile(id);
    });
  }

  Future _deleteProfile(emit,{required int id}) async{
    await _wrapLoader(emit, fn: ()async{
      await _profileRepo.deleteProfile(id: id);
      await _getCurrentProfile();
      await _getAllProfiles();
    });

  }


  _wrapLoader(emit,{required Function fn}) async{
    emit(state.setState(isLoading: true));
    await fn();
    emit(state.setState(
        isLoading: false,
        currentProfile: _currentProfile,
        allProfiles: _allProfiles
    ));
  }

}
