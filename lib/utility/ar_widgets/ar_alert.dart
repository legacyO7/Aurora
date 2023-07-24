import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';

void arAlert({required List<Widget> actions, String content=''}) {
  showDialog(
    barrierDismissible: false,
    context: Constants.kScaffoldKey.currentState!.context,
    builder: (context) {
    return AlertDialog(
      title: const Text('Are You Sure?'),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ...actions,
        ArButton(title: 'Cancel', action: () => Navigator.of(context).pop()),
      ],);
  },);
}