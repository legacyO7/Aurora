
import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/user_interface/theme/presentation/state/theme_event.dart';
import 'package:aurora/user_interface/theme/presentation/state/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState>{
  ThemeBloc(this._isarDelegate):super(ThemeStateInit(ThemeMode.system)){
    on<ThemeEventInit>((_, emit) => _getSavedTheme(emit));
    on<ThemeEventSwitch>((_, emit) => _switchTheme(emit));
  }

  final IsarDelegate _isarDelegate;

  ThemeMode _arTheme=ThemeMode.system;

  Future _getSavedTheme(emit) async{
    _arTheme= await _isarDelegate.getTheme();
    emit(ThemeStateSet(_arTheme));
  }

  Future _switchTheme(emit) async{

    switch (_arTheme) {
      case ThemeMode.system:
        _arTheme=ThemeMode.light;
        break;
      case ThemeMode.light:
        _arTheme=ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _arTheme=ThemeMode.system;
        break;
    }
    emit(ThemeStateSet(_arTheme));
    await _saveTheme();
  }

  _saveTheme() async{
    await _isarDelegate.saveTheme(_arTheme);
  }

}