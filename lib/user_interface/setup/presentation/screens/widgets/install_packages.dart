import 'package:flutter/cupertino.dart';

Widget packageInstaller({required List<String> packagesToInstall}){
  return
    packagesToInstall.isNotEmpty?
        Center(child: Text("Nothing to install!")):
    SingleChildScrollView(
    child: Column(
      children: [
        const Text('The following packages need to be installed',textAlign: TextAlign.center,),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: packagesToInstall
                  .map((e) => Text('\n$e',textAlign: TextAlign.center,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),))
                  .toList()

          ),
        )

      ],
    ),
  );
}