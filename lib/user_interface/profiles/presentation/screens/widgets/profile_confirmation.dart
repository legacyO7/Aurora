import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:aurora/utility/ar_widgets/ar_dialog.dart';
import 'package:aurora/utility/ar_widgets/ar_snackbar.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileConfirmation extends StatefulWidget {
  const ProfileConfirmation({Key? key,
    required this.currentProfile,
    required this.allProfileNames
  }) : super(key: key);

  final ArProfileModel currentProfile;
  final List<String> allProfileNames;

  @override
  State<ProfileConfirmation> createState() => _ProfileConfirmationState();
}

class _ProfileConfirmationState extends State<ProfileConfirmation> with GlobalMixin{
  late TextEditingController profileNameController;

  @override
  void initState() {
    profileNameController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    profileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void profileConfirmationDialog(){
      arDialog(
          title: widget.currentProfile.id==2? "Save Profile As":"Rename Profile", subject: '',
          optionalWidget: profileDetails(),
          barrierColor: ArColors.transparent,
          onCancel: ()=>profileNameController.text='',
          onConfirm: (){
            if(profileNameController.text.isNotEmpty) {
              if(widget.currentProfile.profileName!=profileNameController.text&&
                  widget.allProfileNames.any((element) => element==profileNameController.text)){
                arSnackBar(text: '${profileNameController.text} already exists! Try a different name',isPositive: false);
              }else {
                Navigator.pop(context);
                context.read<ProfilesBloc>().add(ProfilesSaveEvent(name: profileNameController.text));
                profileNameController.text='';
              }
            }else{
              Navigator.pop(context);
            }
          });
    }

    return IconButton(
        onPressed: () {
          profileConfirmationDialog();
        },
        tooltip: '${widget.currentProfile.id==2?"save":"rename"} profile',
        icon: Icon(
          widget.currentProfile.id==2?
          Icons.save:
          Icons.drive_file_rename_outline,
          size: 15.sp,
        ));

  }

  Widget profileDetails() {

    String getStateValues(){
      List values=[];
      for(int i = 0; i< Constants.stateTitle.length;i++){
        if(widget.currentProfile.arState.props[i]==true){
          values.add(Constants.stateTitle[i]);
        }
      }
      return values.join(', ');
    }

    InputBorder border =OutlineInputBorder(
      borderSide: BorderSide(color: Color(widget.currentProfile.arMode.colorRad!)));

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
            decoration: InputDecoration(hintText: widget.currentProfile.profileName,
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
              listItem(title: 'Threshold', text: '${widget.currentProfile.threshold}'),
              listItem(title: 'Brightness', text: Constants.brightnessTitle[widget.currentProfile.brightness]),
              listItem(title: 'Mode', text: Constants.modeTitle[widget.currentProfile.arMode.mode!]),
              listItem(title: 'Speed', text: Constants.speedTitle[widget.currentProfile.arMode.speed!]),
              if(super.isMainLine())
              listItem(title: 'State', text: getStateValues()),
            ],
          ),
        ),
          Container()

      ],);
  }
}

