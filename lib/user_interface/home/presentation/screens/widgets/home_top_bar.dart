import 'package:aurora/utility/ar_widgets/ar_extensions.dart';
import 'package:aurora/utility/ar_widgets/ar_top_buttons.dart';
import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeTopBar extends StatelessWidget with GlobalMixin {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
   return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: ArWindowButtons()),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text("Aurora",style: Theme.of(context).textTheme.headlineLarge!.apply(color: context.selectedColor),),
              Text("\tv${Constants.globalConfig.arVersion}",style: TextStyle(fontSize: 1.5.w,fontWeight: FontWeight.bold),),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: context.selectedColorWithAlpha,
                        width: 3.0
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(15.0)
                    ),
                    color: context.selectedColorWithAlpha
                ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                child: Text(super.isMainLine()?"Mainline":"Faustus"),
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Constants.globalConfig.deviceName,textAlign: TextAlign.end,),
            if(Constants.isLoggingEnabled)
            const Text("logging enabled", style: TextStyle(color: ArColors.orange,fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
          ],
        )
      ],);
  }
}
