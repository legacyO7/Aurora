import 'package:aurora/shared/data/io/remote/remote_io_manager/remote_io_manager.dart';
import 'package:aurora/utility/ar_widgets/ar_logger.dart';
import 'package:dio/dio.dart';

class RemoteIOManagerImpl implements RemoteIOManager{

  RemoteIOManagerImpl(this._dio);

  final Dio _dio;

  @override
  Future<Response> fetch({
    required String url
  })async{
    try {
      return await _dio.get(url).timeout(const Duration(seconds: 15));
    }catch(e,stackTrace){
      ArLogger.log(data: e,stackTrace: stackTrace);
      rethrow;
    }
  }

}

