import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> kSnackBar({
  required BuildContext context,
  required String text,
  bool isPositive = true,
  Widget? rightWidget
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        rightWidget??Container()
      ],
    ),
    backgroundColor: isPositive ? Colors.green : Colors.red,
  ));
}
