import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/cupertino.dart';

Widget arRequestDialog({
  required String title,
  String? buttonTitle1,
  String? buttonTitle2,
  Function? onClickButton1,
  Function? onClickButton2
}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(title),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ArButton(title: buttonTitle1??"Okay",
              action: (){
                if(onClickButton1!=null) {
                  onClickButton1();
                }
              }),
          ArButton(
              isSelected: true,
              edgeInsets: const EdgeInsets.only(left: 10),
              title: buttonTitle2??"Cancel",
              action: () {
                if(onClickButton2!=null){
                  onClickButton2();
                }
              }
          )
        ],)
    ],
  );
}