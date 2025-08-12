import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

class AuthorizedInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // final String? token = await AppStorage().get(AppStorageKeys.token);

    // if (token != null && token.isNotEmpty) {
    //   options.headers['Authorization'] = 'Bearer $token';
    //   log('AuthorizedInterceptor: Đã thêm Authorization header.');
    // } else {
    //   log('AuthorizedInterceptor: Không có token. Bỏ qua thêm Authorization header.');
    // }
    handler.next(options);
  }

  // Không xử lý onResponse hay onError ở đây, để UnauthorizedInterceptor xử lý
}
