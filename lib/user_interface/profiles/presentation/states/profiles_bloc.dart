import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/models/profile_model.dart';
import 'package:aurora/user_interface/profiles/domain/repositories/profile_repo.dart';
import 'package:bloc/bloc.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc(this._profileRepo) : super(ProfilesState.init()) {
    on<ProfilesInitEvent>((_, emit)=>_onInit(emit));
  }

  final ProfileRepo _profileRepo;


  Future _onInit(emit) async{
    emit(ProfilesState.loaded(
        allProfiles:  await _profileRepo.getAllProfiles(),
        currentProfile:  await _profileRepo.getCurrentProfile()
    ));
  }

}
