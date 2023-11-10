part of 'profiles_bloc.dart';

abstract class ProfilesEvent {}

class ProfilesInitEvent extends ProfilesEvent {}

class ProfilesReloadEvent extends ProfilesEvent {
  ArProfileModel profile;

  ProfilesReloadEvent(this.profile);
}

class ProfilesSaveEvent extends ProfilesEvent {
  String name;
  ProfilesSaveEvent({required this.name});
}

class ProfilesDeleteEvent extends ProfilesEvent {
  int id;
  ProfilesDeleteEvent({required this.id});

}class ProfilesLoadEvent extends ProfilesEvent {
  int id;
  ProfilesLoadEvent({required this.id});
}
