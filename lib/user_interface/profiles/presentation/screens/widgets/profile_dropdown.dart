import 'package:aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileDropdown extends StatelessWidget {
  ProfileDropdown({Key? key}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<ProfilesBloc, ProfilesState>(
          builder: (context, state) {
            return DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isExpanded: true,
                alignment: Alignment.center,
                value: state.currentProfile!.id,
                items: state.allProfiles.map<DropdownMenuItem<int>>((e) =>
                    DropdownMenuItem<int>(
                        alignment: Alignment.center,
                        value: e.id,
                        child: SizedBox(
                            width: 12.w,
                            child: Text(e.profileName, overflow: TextOverflow.ellipsis,)))).toList(),
                onChanged: (value) {
                  context.read<ProfilesBloc>().add(ProfilesLoadEvent(id: value ?? state.currentProfile!.id!));
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: 13.w,
                ),
                dropdownStyleData:  DropdownStyleData(
                  width: 15.w,
                  maxHeight: 55.h,
                ),
                dropdownSearchData: DropdownSearchData(
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
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
