import 'package:dio/dio.dart';


abstract class DioClient{
  Future<Response> fetch({required String url});
}

class DioClientImpl extends DioClient{
  
  DioClientImpl(this._dio);
  
  final Dio _dio;

  @override
  Future<Response> fetch({
  required String url
  })async{
    try {
      return await _dio.get(url).timeout(const Duration(seconds: 15));
    }catch(e){
      throw Exception(e);
    }
  }

}