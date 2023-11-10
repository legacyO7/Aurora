import 'dart:io';

import 'package:aurora/shared/utility/init_aurora.dart';
import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';

import 'isar_delegate.dart';

class IsarDelegateImpl with GlobalMixin implements IsarDelegate{

  IsarDelegateImpl(this._isarManager);

  final IsarManager _isarManager;

  late ArProfileModel _arProfileModel;

  @override
  String getVersionFromDB(){
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
  Future saveVersion(String version) async{
    _isarManager.arSettingsModel.arVersion=version;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future saveTheme(ThemeMode themeMode) async{
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
  
  @override
  Future<ArProfileModel?> readFromProfileName(String profileName) async{
    await _isarManager.readAllArProfileIsar();
     List<ArProfileModel> profiles= _isarManager.allProfiles.where((element){
       return element.profileName.trim()==profileName.trim();}).toList();
     if(profiles.isNotEmpty){
      return await _isarManager.readArProfileIsar(id: profiles.first.id);
     }else{
       stdout.writeln("no such profiles found");
     }
     return null;
  }

  Future _writeProfile(Function updateModel) async{
    _arProfileModel=ArProfileModel.copyModel(_isarManager.arProfileModel);
    updateModel();

    if(!super.isMainLine()){
      _arProfileModel.arState=_isarManager.arProfileModel.arState;
    }

    if(_arProfileModel!=_isarManager.arProfileModel){

      List<ArProfileModel> profileMatchList=_isarManager.allProfiles.where((element) => element==_arProfileModel).toList();
      if(profileMatchList.isEmpty){
        if (_arProfileModel.id != 2) {
          _arProfileModel.id = 2;
          _arProfileModel.profileName = 'FreeStyle';
        }

        _isarManager.arProfileModel = _arProfileModel;
        await _isarManager.writeArProfileIsar();
      }else{
       _arProfileModel= (await _isarManager.readArProfileIsar(id: profileMatchList.first.id))!;
      }
      
      sl<ProfilesBloc>().add(ProfilesReloadEvent(_arProfileModel));

    }else{
      stdout.writeln("avoiding unnecessary writes");
    }
  }



}