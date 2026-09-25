import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/entity/register_entity.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RegisterUsecase extends UseCaseWithParams<DataMap, RegisterEntity> {
  const RegisterUsecase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<DataMap> call(RegisterEntity params) {
    return _repo.register(registerEntity: params);
  }
}
