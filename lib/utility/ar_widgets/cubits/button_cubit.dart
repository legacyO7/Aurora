import 'package:flutter_bloc/flutter_bloc.dart';

class ArButtonCubit extends Cubit<bool>{
  ArButtonCubit():super(false);
  
  void setLoad()=>emit(true);
  void setUnLoad()=>emit(false);
  
}

class ArButtonHoverCubit extends Cubit<bool>{
  ArButtonHoverCubit():super(false);

  void setHover(bool hover)=>emit(hover);

}