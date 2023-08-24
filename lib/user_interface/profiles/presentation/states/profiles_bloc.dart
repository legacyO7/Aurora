import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc() : super(ProfilesInitial()) {
    on<ProfilesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
