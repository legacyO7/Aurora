import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> arSnackBar({
  required String text,
  bool isPositive = true,
  Widget? rightWidget
}) {
  return ScaffoldMessenger.of(Constants.kScaffoldKey.currentState!.context).showSnackBar(
      SnackBar(
        elevation: 5,

    content: SizedBox(
      height:Constants.kScaffoldKey.currentContext!.size!.height/10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: ArColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          rightWidget??Container()
        ],
      ),
    ),
    backgroundColor: isPositive ? ArColors.green : ArColors.red,
  ));
}
