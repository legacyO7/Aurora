import 'dart:io';

import 'package:aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:aurora/shared/data/shared_data.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:aurora/utility/constants.dart';


class ServiceManagerImpl implements ServiceManager {

  ServiceManagerImpl(this._isarDelegate,this._ioManager);

  final File serviceFile = File(Constants.kServicePath + Constants.kServiceName);

  final IsarDelegate _isarDelegate;
  final IOManager _ioManager;

  @override
  Future createService() async {
    await serviceFile.create();
    await _ioManager.writeToFile(filePath: serviceFile, content: """
[Unit]
Description=To set charging threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
User=root
ExecStart= /bin/bash -c 'echo ${ _isarDelegate.getThreshold()} > ${Constants.globalConfig.kThresholdPath}'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
"""
    );
  }


  @override
  Future updateService() async {
    List<String> serviceContent=await  _ioManager.readFile(serviceFile);
    int threshold= _isarDelegate.getThreshold();
    serviceContent=serviceContent.map((content){
      if(content.startsWith('ExecStart')){
        return "ExecStart= /bin/bash -c 'echo $threshold > ${Constants.globalConfig.kThresholdPath}'";
      }else{
        return content;
      }
    }).toList();


    await _ioManager.writeToFile(filePath: serviceFile, content: serviceContent.join('\n'));
  }

  @override
  Future deleteService() async{
    if(await serviceFile.exists()) {
      try {
        await serviceFile.delete();
      }catch(e){
        ArLogger.log(data: e);
      }
    }
  }

}