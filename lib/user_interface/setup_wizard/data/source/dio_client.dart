import 'package:dio/dio.dart';


abstract class DioClient{
  Future<dynamic> getResponse({required String url});
}

class DioClientImpl extends DioClient{
  final Dio _dio =Dio();

  @override
  Future<dynamic> getResponse({
  required String url
  })async{
    return await _dio.get(url);
  }

}