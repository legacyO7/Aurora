part of 'profiles_bloc.dart';

enum ProfileStates {init, loaded}

class ProfilesState {

  ProfileStates state;
  List<ProfileModel> allProfiles;
  ArProfileModel? currentProfile;
  bool isLoading;

  ProfilesState._({
    this.state=ProfileStates.init,
    this.allProfiles=const[],
    this.currentProfile,
    this.isLoading=true
  });

  ProfilesState.init():this._();

  ProfilesState.loaded({
    required List<ProfileModel> allProfiles,
    required ArProfileModel currentProfile
  }):this._(
    state: ProfileStates.loaded,
    allProfiles: allProfiles,
    currentProfile: currentProfile,
    isLoading: false
  );

  ProfilesState setState({
    ProfileStates? state,
    List<ProfileModel>? allProfiles,
    ArProfileModel? currentProfile,
    bool? isLoading
   })=>ProfilesState._(
    state: state??this.state,
    allProfiles: allProfiles??this.allProfiles,
    currentProfile: currentProfile??this.currentProfile,
    isLoading: isLoading??this.isLoading
  );


}

