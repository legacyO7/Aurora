import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget grantAccess(){
  return InkWell(
    onTap: (){
      if (kDebugMode) {
        print("grant access");
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: const Text("Grant Access"),
    ),
  );
}