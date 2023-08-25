part of 'profiles_bloc.dart';

enum ProfileStates {init, loaded}

class ProfilesState {

  ProfileStates state;
  List<ProfileModel> allProfiles;
  ArProfileModel? currentProfile;

  ProfilesState._({
    this.state=ProfileStates.init,
    this.allProfiles=const[],
    this.currentProfile
  });

  ProfilesState.init():this._();

  ProfilesState.loaded({
    required List<ProfileModel> allProfiles,
    required ArProfileModel currentProfile
  }):this._(
    state: ProfileStates.loaded,
    allProfiles: allProfiles,
    currentProfile: currentProfile
  );

  ProfilesState setState({
    ProfileStates? state,
    List<ProfileModel>? allProfiles,
    ArProfileModel? currentProfile
   })=>ProfilesState._(
    state: state??this.state,
    allProfiles: allProfiles??this.allProfiles,
    currentProfile: currentProfile??this.currentProfile
  );


}

