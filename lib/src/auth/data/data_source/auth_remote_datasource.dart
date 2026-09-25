import 'package:b2b_seller/core/base/base_repository.dart';
import 'package:b2b_seller/core/injection/instances/dio_http_client.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/data/model/register_model.dart';
import 'package:b2b_seller/src/auth/data/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  ResultFuture<DataMap> login({
    required String email,
    required String password,
    required Role role,
  });
  ResultFuture<DataMap> register({
    required RegisterModel registerModel,
  });
  ResultFuture<DataMap> refreshToken({
    required String refreshToken,
  });
  ResultFuture<bool> logout();
  ResultFuture<UserModel> me();
  ResultFuture<DataMap> patchMe({
    required String? firstName,
    required String? lastName,
    required String? phone,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource
    with RemoteSafeRunner {
  AuthRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  ResultFuture<DataMap> login({
    required String email,
    required String password,
    required Role role,
  }) async {
    return runSafely<DataMap>(() async {
      final dataToSend = {
        'email': email,
        'password': password,
        'role': role.name,
      };
      final response = await dio.post<DataMap>(
        '/auth/login',
        data: dataToSend,
        options: Options(
          extra: const {
            RequestInterceptor.skipDirectingLoginExtraKey: true,
            RequestInterceptor.skipTokenRefreshExtraKey: true,
          },
        ),
      );
      return _dataFromResponse(response.data);
    });
  }

  @override
  ResultFuture<DataMap> register({
    required RegisterModel registerModel,
  }) {
    return runSafely<DataMap>(() async {
      final dataToSend = registerModel.toMap();
      final response = await dio.post<DataMap>(
        '/auth/register',
        data: dataToSend,
        options: Options(
          extra: const {
            RequestInterceptor.skipDirectingLoginExtraKey: true,
            RequestInterceptor.skipTokenRefreshExtraKey: true,
          },
        ),
      );
      return _dataFromResponse(response.data);
    });
  }

  @override
  ResultFuture<DataMap> refreshToken({
    required String refreshToken,
  }) {
    return runSafely<DataMap>(() async {
      final dataToSend = {
        'refresh_token': refreshToken,
      };
      final response = await dio.post<DataMap>(
        '/auth/refresh',
        data: dataToSend,
        options: Options(
          extra: const {
            RequestInterceptor.skipDirectingLoginExtraKey: true,
            RequestInterceptor.skipTokenRefreshExtraKey: true,
          },
        ),
      );
      return _dataFromResponse(response.data);
    });
  }

  @override
  ResultFuture<UserModel> me() {
    return runSafely<UserModel>(() async {
      final response = await dio.get<DataMap>(
        '/auth/me',
        options: Options(
          extra: const {
            RequestInterceptor.skipDirectingLoginExtraKey: true,
          },
        ),
      );
      final data = _dataFromResponse(response.data);
      final result = UserModel.fromMap(data['user'] as DataMap);
      return result;
    });
  }

  @override
  ResultFuture<DataMap> patchMe({
    required String? firstName,
    required String? lastName,
    required String? phone,
  }) {
    return runSafely<DataMap>(() async {
      final response = await dio.patch<DataMap>(
        '/auth/me',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
        },
      );
      return _dataFromResponse(response.data);
    });
  }

   @override
  ResultFuture<bool> logout() {
    return runSafely<bool>(() async {
      await dio.post<void>('/auth/logout');
      return true;
    });
  }

  DataMap _dataFromResponse(DataMap? response) {
    final data = response?['data'];
    if (data is Map<String, dynamic>) return data;
    return response ?? <String, dynamic>{};
  }
}
