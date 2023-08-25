import 'dart:io';

import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:flutter/material.dart';

import 'isar_delegate.dart';

class IsarDelegateImpl implements IsarDelegate{

  IsarDelegateImpl(this._isarManager);

  final IsarManager _isarManager;

  late ArProfileModel _arProfileModel;

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
  int getThreshold(){
    return _isarManager.arProfileModel.threshold;
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
  Future<ArProfileModel> getArProfile({int? id}) async{
    return (await _isarManager.readArProfileIsar(id: id))!;
  }

  @override
  Future setBrightness(int brightness) async {
    await _writeProfile(()=>_arProfileModel.brightness=brightness);
  }

  @override
  Future setArMode({ required ArMode arMode}) async {
    await _writeProfile(() {
      _arProfileModel.arMode=ArMode.copyModel(arMode);
    });
  }

  @override
  Future setArState({ required ArState arState }) async {
    await _writeProfile(()=> _arProfileModel.arState =arState);

  }

  @override
  Future setThreshold(int threshold) async {
    await _writeProfile(()=>_arProfileModel.threshold=threshold);
  }

  @override
  Future deleteDatabase() async{
    await _isarManager.deleteDatabase();
  }

  Future _writeProfile(Function updateModel) async{
    _arProfileModel=ArProfileModel.copyModel(_isarManager.arProfileModel);
    updateModel();
    if(_arProfileModel!=_isarManager.arProfileModel){
      _isarManager.arProfileModel=_arProfileModel;
      if(_isarManager.arProfileModel.id!=2){
        _isarManager.arProfileModel.id=2;
        _isarManager.arProfileModel.profileName='FreeStyle';
      }

      await _isarManager.writeArProfileIsar();

    }else{
      stdout.writeln("avoiding unnecessary writes");
    }
  }

}