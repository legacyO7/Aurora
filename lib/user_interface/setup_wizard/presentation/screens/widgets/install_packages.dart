import 'package:flutter/cupertino.dart';

Widget packageInstaller(){
  return const Text("""
            Aurora wants to configure your system
            
            The following packages need to be installed
            
dkms\n
openssl\n
mokutil\n
xterm\n
wget\n
git\n
pkexec\n
make\n
cmake
                """,textAlign: TextAlign.center,);
}