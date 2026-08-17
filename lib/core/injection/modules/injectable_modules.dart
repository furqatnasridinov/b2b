import 'package:b2b_seller/core/injection/instances/dio_http_client.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectableModules {
  @lazySingleton
  Dio get dio => DioHttpClient.instance;

  // Register FlutterSecureStorage
  //@lazySingleton
  //FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();
}
