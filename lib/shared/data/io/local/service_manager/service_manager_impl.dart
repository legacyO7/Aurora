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
  Future createService({String? serviceFilePath}) async {
    File servFile=serviceFilePath==null?serviceFile:File(serviceFilePath);
    await servFile.create();
    await _ioManager.writeToFile(filePath: servFile, content: _getServiceFileContent
    );
  }




@override
String get createServiceContentByShell =>
   "tee $serviceFile > /dev/null << 'EOF'\n${_getServiceFileContent}EOF";


  String get _getServiceFileContent =>
     """
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
""";


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