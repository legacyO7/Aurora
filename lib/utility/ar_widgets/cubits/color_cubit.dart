import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ArColorCubit extends Cubit<Color> {
  ArColorCubit() : super(Colors.transparent);

  Color _selectedColor=ArColors.accentColor;
  
  setSelectedColor({
    required Color selectedColor,
  }){
     _selectedColor=selectedColor;
     emit(selectedColor);
  }

  Color get selectedColor=>_selectedColor;
  Color get selectedColorWithAlpha=>_selectedColor.withAlpha(50);
  Color get invertedColor=> Color.fromARGB(
      (selectedColor.opacity * 255).round(),
      255-selectedColor.red,
      255-selectedColor.green,
      255-selectedColor.blue);   
  
}
