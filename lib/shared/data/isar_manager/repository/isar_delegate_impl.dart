import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:flutter/material.dart';

import 'isar_delegate.dart';

class IsarDelegateImpl implements IsarDelegate{

  IsarDelegateImpl(this._isarManager);

  final IsarManager _isarManager;

  @override
  String getVersion(){
    return  (_isarManager.arSettingsModel.arVersion)??'0';
  }

  @override
  Future<ThemeMode> getTheme() async{
    switch((_isarManager.arSettingsModel.arTheme)??'system'){
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;

      default:
        return ThemeMode.system;
    }

  }

  @override
  bool getEnforceFaustus(){
    return  _isarManager.arSettingsModel.enforceFaustus;
  }


  @override
  Future setVersion(String version) async{
    _isarManager.arSettingsModel.arVersion=version;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future setTheme(ThemeMode themeMode) async{
    _isarManager.arSettingsModel.arTheme=themeMode.name;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future setEnforceFaustus(bool enforced) async{
    _isarManager.arSettingsModel.enforceFaustus=enforced;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future deleteDatabase() async{
    await _isarManager.deleteDatabase();
  }


}