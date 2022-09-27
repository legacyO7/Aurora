import 'package:flutter_bloc/flutter_bloc.dart';

class ArButtonCubit extends Cubit<bool>{
  ArButtonCubit():super(false);
  
  setLoad()=>emit(true);
  setUnLoad()=>emit(false);
  
}