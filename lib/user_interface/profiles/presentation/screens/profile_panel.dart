import 'package:aurora/shared/data/isar_manager/repository/isar_manager_impl.dart';
import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePanel extends StatelessWidget {
  const ProfilePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.selectedColor,width: .2.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () async{
                IsarManagerImpl _hiveManager=IsarManagerImpl();
                _hiveManager.initIsar();
              },
              tooltip: "Add new profile",
              icon: const Icon(Icons.add)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: context.selectedColorWithAlpha,width: .2.w))),
              child: Row(
                children: [
                  Text("Default Profile"),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.save)),
                ],
              )),
          IconButton(
              onPressed: (){},
              tooltip: "delete current profile",
              icon: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}
