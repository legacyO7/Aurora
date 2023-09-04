import 'package:aurora/user_interface/profiles/presentation/screens/widgets/profile_confirmation.dart';
import 'package:aurora/user_interface/profiles/presentation/screens/widgets/profile_dropdown.dart';
import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_alert.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
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
                  child: ProfileDropdown()),
              if(state.currentProfile!.id!!=1)
                ProfileConfirmation(currentProfile: state.currentProfile!),
              if(state.currentProfile!.id!>2)
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
                  icon: Icon(Icons.remove, size: 15.sp,)),
            ],
          );
        },
      ),
    );
  }
}
