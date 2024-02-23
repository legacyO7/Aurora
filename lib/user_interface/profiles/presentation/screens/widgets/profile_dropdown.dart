import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileDropdown extends StatelessWidget {
  ProfileDropdown({super.key});

  final TextEditingController textEditingController = TextEditingController();

  Widget titleWidget(String title)=>
      SizedBox(
          width: 12.w,
          child: Text(title, overflow: TextOverflow.ellipsis,));


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<ProfilesBloc, ProfilesState>(
          builder: (context, state) {
            return
              state.allProfiles.length>1?
              DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isExpanded: true,
                alignment: Alignment.center,
                value: state.currentProfile!.id,
                items: state.allProfiles.map<DropdownMenuItem<int>>((e) =>
                    DropdownMenuItem<int>(
                        alignment: Alignment.center,
                        value: e.id,
                        child: titleWidget(e.profileName))).toList(),
                onChanged: (value) {
                  context.read<ProfilesBloc>().add(ProfilesLoadEvent(id: value ?? state.currentProfile!.id!));
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: state.currentProfile!.id==1?18.w:13.w,
                ),
                dropdownStyleData:  DropdownStyleData(
                  width: 15.w,
                  maxHeight: 55.h,
                ),
                dropdownSearchData:
                state.allProfiles.length>5?
                DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 8.h,
                  searchInnerWidget: Container(
                    height: 8.h,
                    padding:  EdgeInsets.symmetric(vertical: 1.h),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.selectedColorWithAlpha,width: .2.w),),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.selectedColor,width: .1.w),),
                        hintText: 'Search Profiles',
                        hintStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                  searchMatchFn: (item, searchValue) {
                    return state.allProfiles.any((element) =>
                        element.id==item.value&&
                        element.profileName.toLowerCase().contains(searchValue.toLowerCase()));
                  },
                ):null,
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ):
            SizedBox(
              width: 17.w,
              child: Center(child: titleWidget(state.currentProfile!.profileName)),
            );
          },
        ),
      ],
    );
  }
}
