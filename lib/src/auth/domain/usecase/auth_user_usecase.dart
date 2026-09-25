import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/entity/user_entity.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCurrentUserUsecase extends UseCaseWithoutParams<UserEntity> {
  const GetCurrentUserUsecase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserEntity> call() => _repo.me();
}

@lazySingleton
class UpdateCurrentUserUsecase
    extends UseCaseWithParams<DataMap, DataMap> {
  const UpdateCurrentUserUsecase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<DataMap> call(DataMap params) {
    return _repo.patchMe(
      firstName: params['first_name'] as String?,
      lastName: params['last_name'] as String?,
      phone: params['phone'] as String?,
    );
  }
}
