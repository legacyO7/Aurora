
import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:aurora/user_interface/keyboard_settings/entity/keyboard_settings_entity.dart';
import 'package:aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState> {
  KeyboardSettingsBloc(this._isarDelegate):super(const KeyboardSettingsState()){

   on<KeyboardSettingsEventInit>((event, emit) => _initPanel(emit));
   on<KeyboardSettingsEventSetBrightness>((event, emit)=> _setBrightness(event.brightness,emit));
   on<KeyboardSettingsEventSetSpeed>((event, emit)=> _setSpeed(speed: event.speed,emit));
   on<KeyboardSettingsEventSetMode>((event, emit)=> _setMode(mode: event.mode,emit));
   on<KeyboardSettingsEventSetColor>((event, emit)=> _setColor(color: event.color??ArColors.accentColor,mode: 0, emit));
   on<KeyboardSettingsEventSetState>((event, emit) => _setStateParams(emit,arState: ArState(boot: event.boot,sleep: event.sleep,awake: event.awake)));
  }

  final IsarDelegate _isarDelegate;
  final KeyboardSettingsRepo _keyboardSettingsRepo=KeyboardSettingsEntity.getRepo();

  bool _boot=false;
  bool _awake=false;
  bool _sleep=false;

  late ArMode arMode;

  late ArProfileModel arProfileModel;

  _initPanel(emit) async{
      arProfileModel=await _isarDelegate.getArProfile();
      arMode= ArMode.copyModel(arProfileModel.arMode);
      if(Constants.globalConfig.isBacklightControllerEnabled) {
        await _setBrightness(arProfileModel.brightness, emit);
        await _setModeParams(arMode: arMode, emit);
        if (super.isMainLine()) {
          await _setStateParams(arState: (arProfileModel.arState).negateValue(), emit);
        }
      }
  }

  _setColor(emit,{required Color color,int? mode}) async {
    arMode.color= color;
    arMode.colorRad=color.value;
    arMode.mode=mode??arMode.mode;

    await _keyboardSettingsRepo.setColor(arMode: ArMode.copyModel(arMode));
    _updateState(emit);
  }

  _setBrightness(int brightness, emit) async {
    await _keyboardSettingsRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  _setMode(emit, {required int mode})async{
    arMode.mode=mode;
    await _keyboardSettingsRepo.setMode(arMode: arMode);
    _updateState(emit);
  }

  _setSpeed(emit,{required int speed}) async{
    arMode.speed=speed;
    await _keyboardSettingsRepo.setSpeed(arMode: arMode);
    _updateState(emit);
  }
  
  _setModeParams(emit,{
    required ArMode arMode    
  }) async{
    this.arMode.color=arMode.color??this.arMode.color;
    this.arMode.mode=arMode.mode??this.arMode.mode;
    this.arMode.speed=arMode.speed??this.arMode.speed;
    await _keyboardSettingsRepo.setModeParams(arMode: arMode);
    _updateState(emit);
  }
  
  _setStateParams(emit,{
    required ArState arState
  }) async{
    _boot=arState.boot==null?_boot:!arState.boot!;
    _awake=arState.awake==null?_awake:!arState.awake!;
    _sleep=arState.sleep==null?_sleep:!arState.sleep!;
    await _keyboardSettingsRepo.setMainlineStateParams(arState: ArState(awake: _awake,boot: _boot,sleep: _sleep));
    _updateState(emit);
  }

  _updateState(emit){
    super.setSelectedColor(arMode.color!);
    emit(state.copyState(speed: arMode.speed,mode: arMode.mode,color: arMode.color,awake: _awake,sleep: _sleep,boot: _boot));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

}