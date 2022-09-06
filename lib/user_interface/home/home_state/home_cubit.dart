import 'package:aurora/user_interface/home/home_state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeStateInit());

}