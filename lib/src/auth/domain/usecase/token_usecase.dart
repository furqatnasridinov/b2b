import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAccessTokenUseCase extends UseCaseWithoutParams<String?> {
  const GetAccessTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call() {
    return _repo.getAccessToken();
  }
}

@lazySingleton
class SaveAccessTokenUseCase extends UseCaseWithParams<void, String> {
  const SaveAccessTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) {
    return _repo.saveAccessToken(params);
  }
}

@lazySingleton
class DeleteAccessTokenUseCase extends UseCaseWithoutParams<void> {
  const DeleteAccessTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call() {
    return _repo.removeAccessToken();
  }
}

@lazySingleton
class GetRefreshTokenUseCase extends UseCaseWithoutParams<String?> {
  const GetRefreshTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call() {
    return _repo.getRefreshToken();
  }
}

@lazySingleton
class SaveRefreshTokenUseCase extends UseCaseWithParams<void, String> {
  const SaveRefreshTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) {
    return _repo.saveRefreshToken(params);
  }
}

@lazySingleton
class DeleteRefreshTokenUseCase extends UseCaseWithoutParams<void> {
  const DeleteRefreshTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call() {
    return _repo.removeRefreshToken();
  }
}

@lazySingleton
class RefreshTokenUseCase extends UseCaseWithParams<DataMap, String> {
  const RefreshTokenUseCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<DataMap> call(String params) {
    return _repo.refreshToken(refreshToken: params);
  }
}
