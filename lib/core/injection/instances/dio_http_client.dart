// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class DioHttpClient {
  const DioHttpClient._();

  static Dio? _dioInstance;
  static Dio get instance {
    _dioInstance ??= _buildDio();
    return _dioInstance!;
  }

  static Dio _buildDio() {
    final dio = Dio(_options);
    //..interceptors.add(_requestInterceptor)
    //..interceptors.add(_loggerInterceptor);
    return dio;
  }

  static BaseOptions get _options => BaseOptions(
    baseUrl: dotenv.get('BASE_URL'),
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(seconds: 180),
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.acceptHeader: 'application/json, text/plain, */*',
    },
  );
}

class RequestInterceptor extends Interceptor {
  RequestInterceptor();


  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // User-Agent
    //final userAgent = await UserAgentProvider.getUserAgent();
    //options.headers['User-Agent'] = userAgent;

    // Accept-Language
    //final locale = LocalDataStorage.getLocale();
    //options.headers['Accept-Language'] = locale;

    // Гео (по желанию — не логируйте в прод)
    /* final latitude = LocalDataStorage.getLatitude();
    final longitude = LocalDataStorage.getLongitude();
    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      options.headers['x-geo-lat'] = latitude;
      options.headers['x-geo-lng'] = longitude;
    } */

    //options.headers['Authorization'] = 'Bearer $token';

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode ?? 0;
    final uriStr = err.requestOptions.uri.toString();
    // here you can add logic 
    return handler.next(err);
  }
}
