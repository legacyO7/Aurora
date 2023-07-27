import 'package:dio/dio.dart';

abstract class RemoteIOManager{
  Future<Response> fetch({required String url});
}