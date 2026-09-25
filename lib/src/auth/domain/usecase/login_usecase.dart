import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoginUsecase extends UseCaseWithParams<DataMap, DataMap> {
  const LoginUsecase(this.authRepo);

  final AuthRepo authRepo;

  @override
  ResultFuture<DataMap> call(DataMap params) {
    return authRepo.login(
      email: params['email'] as String,
      password: params['password'] as String,
      role: params['role'] as Role,
    );
  }
}

