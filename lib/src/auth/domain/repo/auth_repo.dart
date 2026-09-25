import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/utils.dart';
import 'package:b2b_seller/src/auth/domain/entity/entity.dart';

abstract class AuthRepo {
  //------ Remote Actions ------
  ResultFuture<DataMap> register({
    required RegisterEntity registerEntity,
  });
  ResultFuture<DataMap> login({
    required String email,
    required String password,
    required Role role,
  });
  ResultFuture<bool> logout();
  ResultFuture<DataMap> refreshToken({required String refreshToken});
  ResultFuture<UserEntity> me();
  ResultFuture<DataMap> patchMe({
    required String? firstName,
    required String? lastName,
    required String? phone,
  });

  //------ Local Actions ------
  ResultFuture<String> getAccessToken();
  ResultFuture<void> saveAccessToken(String token);
  ResultFuture<void> removeAccessToken();
  ResultFuture<String> getRefreshToken();
  ResultFuture<void> saveRefreshToken(String token);
  ResultFuture<void> removeRefreshToken();
}
