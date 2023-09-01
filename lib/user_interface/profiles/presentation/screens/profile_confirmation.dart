import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_dialog.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileConfirmation extends StatelessWidget with GlobalMixin {
  ProfileConfirmation({Key? key, required this.currentProfile}) : super(key: key);

  final ArProfileModel currentProfile;
  final TextEditingController profileNameController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    void profileConfirmationDialog(){
      arDialog(

          title: currentProfile.id==2? "Save Profile As":"Rename Profile", subject: '',
          optionalWidget: profileDetails(),
          onConfirm: (){
            Navigator.pop(context);
            if(profileNameController.text.isNotEmpty) {
              context.read<ProfilesBloc>().add(ProfilesSaveEvent(name: profileNameController.text));
            }
          });
    }

    return IconButton(
        onPressed: () {
          profileConfirmationDialog();
        },
        tooltip: '${currentProfile.id==2?"save":"rename"} profile',
        icon: Icon(
          currentProfile.id==2?
          Icons.save:
          Icons.drive_file_rename_outline,
          size: 15.sp,
        ));

  }

  Widget profileDetails() {

    String getStateValues(){
      List values=[];
      for(int i = 0; i< Constants.stateTitle.length;i++){
        if(currentProfile.arState.props[i]==true){
          values.add(Constants.stateTitle[i]);
        }
      }
      return values.join(', ');
    }

    InputBorder border =OutlineInputBorder(
      borderSide: BorderSide(color: Color(currentProfile.arMode.colorRad!)));

    Widget listItem({required String title,required String text}){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Container()),
          Expanded(child: Text(title)),
          const Expanded(child: Center(child: Text(":"))),
          Expanded(child: Container()),
          Expanded(child: Text(text)),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      IntrinsicWidth(
        child: TextField(
          controller: profileNameController,
          decoration: InputDecoration(hintText: currentProfile.profileName,
            focusedBorder: border,
            enabledBorder: border,
            ),
          ),
        ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            listItem(title: 'Threshold', text: '${currentProfile.threshold}'),
            listItem(title: 'Brightness', text: Constants.brightnessTitle[currentProfile.brightness]),
            listItem(title: 'Mode', text: Constants.modeTitle[currentProfile.arMode.mode!]),
            listItem(title: 'Speed', text: Constants.speedTitle[currentProfile.arMode.speed!]),
            if(super.isMainLine())
            listItem(title: 'State', text: getStateValues()),
          ],
        ),
      ),
        Container()

    ],);
  }
}

