import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequestInterceptor extends Interceptor {
  RequestInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log('🌐 [${options.method}] ${options.uri}');
      if (options.data != null) {
        log('📦 Request Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        log('🔍 Query Parameters: ${options.queryParameters}');
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('✅ [${response.statusCode}] ${response.requestOptions.uri}');
      log('📥 Response: ${response.data}');
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('❌ [${err.response?.statusCode}] ${err.requestOptions.uri}');
      log('📛 Error: ${err.message}');
      if (err.response?.data != null) {
        log('📦 Error Response: ${err.response?.data}');
      }
    }

    // Handle specific error status codes
    if (err.response != null) {
      switch (err.response?.statusCode) {
        case 400:
          return handler.reject(BadRequestException(err));
        case 401:
          return handler.reject(UnauthorizedException(err));
        case 403:
          return handler.reject(ForbiddenException(err));
        case 404:
          return handler.reject(NotFoundException(err));
        case 408:
          return handler.reject(RequestTimeoutException(err));
        case 500:
          return handler.reject(InternalServerErrorException(err));
        case 502:
          return handler.reject(BadGatewayException(err));
        case 503:
          return handler.reject(ServiceUnavailableException(err));
        case 504:
          return handler.reject(GatewayTimeoutException(err));
        default:
          return handler.reject(NetworkException(err));
      }
    }

    // Handle no internet connection
    if (err.type == DioExceptionType.connectionError) {
      return handler.reject(NoInternetConnectionException(err));
    }

    // Handle timeout
    if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return handler.reject(RequestTimeoutException(err));
    }

    return handler.next(err);
  }

  void handleError(
    Response response,
    ResponseInterceptorHandler handler,
    int statusCode,
  ) {
    if (statusCode >= 400) {
      DioException dioError = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.data,
      );

      switch (statusCode) {
        case 400:
          return handler.reject(BadRequestException(dioError));
        case 401:
          return handler.reject(UnauthorizedException(dioError));
        case 403:
          return handler.reject(ForbiddenException(dioError));
        case 404:
          return handler.reject(NotFoundException(dioError));
        case 408:
          return handler.reject(RequestTimeoutException(dioError));
        case 500:
          return handler.reject(InternalServerErrorException(dioError));
        case 502:
          return handler.reject(BadGatewayException(dioError));
        case 503:
          return handler.reject(ServiceUnavailableException(dioError));
        case 504:
          return handler.reject(GatewayTimeoutException(dioError));
        default:
          return handler.reject(NetworkException(dioError));
      }
    }
  }
}

// Custom exceptions
class NetworkException extends DioException {
  NetworkException(DioException dioError)
    : super(
        requestOptions: dioError.requestOptions,
        response: dioError.response,
        error: dioError.error,
        type: dioError.type,
      );
}

class BadRequestException extends NetworkException {
  BadRequestException(super.dioError);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.dioError);
}

class ForbiddenException extends NetworkException {
  ForbiddenException(super.dioError);
}

class NotFoundException extends NetworkException {
  NotFoundException(super.dioError);
}

class RequestTimeoutException extends NetworkException {
  RequestTimeoutException(super.dioError);
}

class InternalServerErrorException extends NetworkException {
  InternalServerErrorException(super.dioError);
}

class BadGatewayException extends NetworkException {
  BadGatewayException(super.dioError);
}

class ServiceUnavailableException extends NetworkException {
  ServiceUnavailableException(super.dioError);
}

class GatewayTimeoutException extends NetworkException {
  GatewayTimeoutException(super.dioError);
}

class NoInternetConnectionException extends NetworkException {
  NoInternetConnectionException(super.dioError);
}
