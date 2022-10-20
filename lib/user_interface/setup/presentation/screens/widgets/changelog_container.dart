import 'package:aurora/utility/ar_widgets/colors.dart';
import 'package:flutter/material.dart';

Widget changelogContainer({required String changelog}){
  return Flexible(child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration:  BoxDecoration(
          border: Border.all(color: ArColors.accentColor)
      ),
      child: SingleChildScrollView(child: Text(changelog))));
}