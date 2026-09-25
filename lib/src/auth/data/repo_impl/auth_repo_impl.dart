import 'package:b2b_seller/core/base/base_repository.dart';
import 'package:b2b_seller/core/errors/failures.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/data/data_source/auth_local_datasource.dart';
import 'package:b2b_seller/src/auth/data/data_source/auth_remote_datasource.dart';
import 'package:b2b_seller/src/auth/data/model/register_model.dart';
import 'package:b2b_seller/src/auth/domain/entity/register_entity.dart';
import 'package:b2b_seller/src/auth/domain/entity/user_entity.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl extends AuthRepo with RemoteSafeRunner {
  AuthRepoImpl(
    this.authLocalDataSource,
    this.authRemoteDataSource,
  );

  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  ResultFuture<DataMap> register({
    required RegisterEntity registerEntity,
  }) async {
    final result = await authRemoteDataSource.register(
      registerModel: RegisterModel.fromEntity(registerEntity),
    );
    return result.fold(Left.new, _saveTokensAndReturnData);
  }

  @override
  ResultFuture<DataMap> refreshToken({
    required String refreshToken,
  }) {
    return authRemoteDataSource.refreshToken(refreshToken: refreshToken);
  }

  @override
  ResultFuture<DataMap> login({
    required String email,
    required String password,
    required Role role,
  }) async {
    final result = await authRemoteDataSource.login(
      email: email,
      password: password,
      role: role,
    );
    return result.fold(Left.new, _saveTokensAndReturnData);
  }

  @override
  ResultFuture<bool> logout() async {
    final result = await authRemoteDataSource.logout();
    return result.fold(
      Left.new,
      (isLoggedOut) async {
        final clearResult = await runSafely<void>(() async {
          await Future.wait([
            authLocalDataSource.removeAccessToken(),
            authLocalDataSource.removeRefreshToken(),
          ]);
        });
        return clearResult.fold(Left.new, (_) => Right(isLoggedOut));
      },
    );
  }

  @override
  ResultFuture<UserEntity> me() {
    return authRemoteDataSource.me();
  }

  @override
  ResultFuture<DataMap> patchMe({
    required String? firstName,
    required String? lastName,
    required String? phone,
  }) {
    return authRemoteDataSource.patchMe(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }

  @override
  ResultFuture<String> getRefreshToken() {
    return runSafely<String>(() async {
      return authLocalDataSource.getRefreshToken();
    });
  }

  @override
  ResultFuture<void> removeRefreshToken() {
    return runSafely<void>(() async {
      return authLocalDataSource.removeRefreshToken();
    });
  }

  @override
  ResultFuture<void> saveRefreshToken(String token) {
    return runSafely<void>(() async {
      return authLocalDataSource.saveRefreshToken(token);
    });
  }

  @override
  ResultFuture<String> getAccessToken() {
    return runSafely<String>(() async {
      return authLocalDataSource.getAccessToken();
    });
  }

  @override
  ResultFuture<void> removeAccessToken() {
    return runSafely<void>(() async {
      return authLocalDataSource.removeAccessToken();
    });
  }

  @override
  ResultFuture<void> saveAccessToken(String token) {
    return runSafely<void>(() async {
      return authLocalDataSource.saveAccessToken(token);
    });
  }

  Future<Either<Failure, DataMap>> _saveTokensAndReturnData(
    DataMap data,
  ) async {
    final accessToken = data['access_token'] as String? ?? '';
    final refreshToken = data['refresh_token'] as String? ?? '';
    final saveResult = await runSafely<void>(() async {
      if (accessToken.isNotEmpty) {
        await authLocalDataSource.saveAccessToken(accessToken);
      }
      if (refreshToken.isNotEmpty) {
        await authLocalDataSource.saveRefreshToken(refreshToken);
      }
    });
    return saveResult.fold(Left.new, (_) => Right(data));
  }
}
