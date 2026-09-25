import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LogoutUsecase extends UseCaseWithoutParams<bool> {
  const LogoutUsecase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<bool> call() => _repo.logout();
}
