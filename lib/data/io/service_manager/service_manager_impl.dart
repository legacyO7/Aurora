import 'dart:io';

import 'package:aurora/data/io/io_manager/io_manager.dart';
import 'package:aurora/data/shared_preference/pref_repo.dart';
import 'package:aurora/utility/constants.dart';

import 'service_manager.dart';

class ServiceManagerImpl implements ServiceManager {

  ServiceManagerImpl(this._prefRepo,this._ioManager);

  final File serviceFile = File(Constants.kServicePath + Constants.kServiceName);

  final PrefRepo _prefRepo;
  final IOManager _ioManager;

  @override
  Future createService() async {
    await serviceFile.create();
    await serviceFile.writeAsString("""
[Unit]
Description=To set charging threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
User=root
ExecStart= /bin/bash -c 'echo ${(await _prefRepo.getThreshold() ?? Constants.kMinimumChargeLevel)} > ${Constants.globalConfig.kThresholdPath}'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
"""
    );
  }


  @override
  Future updateService() async {
    List<String> serviceContent=await  _ioManager.readFile(serviceFile);
    int threshold=await _prefRepo.getThreshold() ?? Constants.kMinimumChargeLevel;
    serviceContent=serviceContent.map((content){
      if(content.startsWith('ExecStart')){
        return "ExecStart= /bin/bash -c 'echo $threshold > ${Constants.globalConfig.kThresholdPath}'";
      }else{
        return content;
      }
    }).toList();

    await serviceFile.writeAsString(serviceContent.join('\n'));
  }

  @override
  Future deleteService() async{
   await serviceFile.delete();
  }

}