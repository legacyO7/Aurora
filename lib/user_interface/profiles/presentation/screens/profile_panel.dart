import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_alert.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/ar_widgets/ar_dialog.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key}) : super(key: key);

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {

  @override
  void initState() {
    context.read<ProfilesBloc>().add(ProfilesInitEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      height: 6.h,
      width: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.selectedColor, width: .2.w),
      ),
      child: BlocBuilder<ProfilesBloc, ProfilesState>(
        builder: (context, state) {
          if(state.isLoading){
           return ClipRRect(
             borderRadius:  BorderRadius.circular(15),
              child: LinearProgressIndicator(
                color: context.selectedColor,
                backgroundColor: context.selectedColorWithAlpha
              ));
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                      border: Border(right: BorderSide(
                          color: context.selectedColorWithAlpha,
                          width: .1.w
                      ))),
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: state.currentProfile!.id,
                            items: state.allProfiles.map<DropdownMenuItem<int>>((e) =>
                            DropdownMenuItem<int>(
                                value: e.id,
                                child: SizedBox(
                                    width: 12.w,
                                    child: Text(e.profileName,overflow: TextOverflow.ellipsis,)))).toList(),
                            onChanged: (value){
                              context.read<ProfilesBloc>().add(ProfilesLoadEvent(id: value??state.currentProfile!.id!));
                            }),
                      )
                    ],
                  )),
              IconButton(
                  onPressed: () {
                    TextEditingController profileNameController=TextEditingController();
                    arDialog(title: "Save Profile As", subject: '',
                        optionalWidget: IntrinsicWidth(
                          child: TextField(
                            controller: profileNameController,
                            decoration: InputDecoration(hintText: state.currentProfile?.profileName??'-'),
                          ),
                        ),
                        onConfirm: (){
                          Navigator.pop(context);
                          context.read<ProfilesBloc>().add(ProfilesSaveEvent(name: profileNameController.text));
                        });
                  },
                  tooltip: "save profile",
                  icon: const Icon(Icons.save)),
              IconButton(
                  onPressed: () {
                    arAlert(
                        content: "Delete ${state.currentProfile!.profileName}",
                        actions: [
                      ArButton(
                          title: "Yes",
                          isSelected: true,
                          action: (){
                        context.read<ProfilesBloc>().add(ProfilesDeleteEvent(id: state.currentProfile!.id!));
                        Navigator.pop(context);
                      })
                    ]);
                  },
                  tooltip: "delete current profile",
                  icon: const Icon(Icons.remove)),
            ],
          );
        },
      ),
    );
  }
}
