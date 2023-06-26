import 'dart:io';

import 'package:aurora/user_interface/home/data/io_manager.dart';

class IOManagerImpl implements IOManager{

  @override
  Future writeToFile({required String path, required String content}) async{
    await File(path).writeAsString(content);
  }

}