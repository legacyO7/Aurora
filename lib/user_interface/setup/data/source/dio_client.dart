import 'package:dio/dio.dart';


abstract class DioClient{
  Future<dynamic> fetch({required String url});
}

class DioClientImpl extends DioClient{
  
  DioClientImpl(this._dio);
  
  final Dio _dio;

  @override
  Future<dynamic> fetch({
  required String url
  })async{
    return await _dio.get(url);
  }

}