import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
// import 'package:pickle_app/core/network/interceptor/authorized_interceptor.dart';
// import 'package:pickle_app/core/network/interceptor/unauthorized_interceptor.dart';
import 'package:pickle_app/core/network/interceptor/request_interceptor.dart';

@lazySingleton
class NetworkClient {
  NetworkClient() {
    _dio = Dio(
      BaseOptions(baseUrl: baseUrl, headers: {'SecretKey': secretKey}),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
    // _dio.interceptors.add(AuthorizedInterceptor());
    // _dio.interceptors.add(UnauthorizedInterceptor());
    _dio.interceptors.add(RequestInterceptor());
  }

  String get baseUrl => 'http://localhost:8080/';
  String get secretKey => '';

  late Dio _dio;

  Dio get dio => _dio;
}
