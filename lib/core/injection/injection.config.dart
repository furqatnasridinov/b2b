// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:b2b_seller/core/common/bloc/app_settings_cubit.dart' as _i841;
import 'package:b2b_seller/core/injection/modules/injectable_modules.dart'
    as _i484;
import 'package:b2b_seller/src/auth/data/data_source/auth_local_datasource.dart'
    as _i123;
import 'package:b2b_seller/src/auth/data/data_source/auth_remote_datasource.dart'
    as _i626;
import 'package:b2b_seller/src/auth/data/repo_impl/auth_repo_impl.dart'
    as _i820;
import 'package:b2b_seller/src/auth/domain/repo/auth_repo.dart' as _i536;
import 'package:b2b_seller/src/auth/domain/usecase/auth_user_usecase.dart'
    as _i911;
import 'package:b2b_seller/src/auth/domain/usecase/login_usecase.dart' as _i856;
import 'package:b2b_seller/src/auth/domain/usecase/logout_usecase.dart'
    as _i995;
import 'package:b2b_seller/src/auth/domain/usecase/register_usecase.dart'
    as _i187;
import 'package:b2b_seller/src/auth/domain/usecase/token_usecase.dart' as _i235;
import 'package:b2b_seller/src/auth/presentation/bloc/auth/auth_cubit.dart'
    as _i560;
import 'package:b2b_seller/src/auth/presentation/bloc/health_check/health_check_cubit.dart'
    as _i117;
import 'package:b2b_seller/src/auth/presentation/bloc/logout/logout_cubit.dart'
    as _i725;
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart'
    as _i384;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectableModules = _$InjectableModules();
    gh.factory<_i841.AppSettingsCubit>(() => _i841.AppSettingsCubit());
    gh.factory<_i117.HealthCheckCubit>(() => _i117.HealthCheckCubit());
    gh.lazySingleton<_i361.Dio>(() => injectableModules.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => injectableModules.flutterSecureStorage,
    );
    gh.lazySingleton<_i123.AuthLocalDataSource>(
      () => _i123.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i626.AuthRemoteDataSource>(
      () => _i626.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i536.AuthRepo>(
      () => _i820.AuthRepoImpl(
        gh<_i123.AuthLocalDataSource>(),
        gh<_i626.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i856.LoginUsecase>(
      () => _i856.LoginUsecase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i911.GetCurrentUserUsecase>(
      () => _i911.GetCurrentUserUsecase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i911.UpdateCurrentUserUsecase>(
      () => _i911.UpdateCurrentUserUsecase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i995.LogoutUsecase>(
      () => _i995.LogoutUsecase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i187.RegisterUsecase>(
      () => _i187.RegisterUsecase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.GetAccessTokenUseCase>(
      () => _i235.GetAccessTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.SaveAccessTokenUseCase>(
      () => _i235.SaveAccessTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.DeleteAccessTokenUseCase>(
      () => _i235.DeleteAccessTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.GetRefreshTokenUseCase>(
      () => _i235.GetRefreshTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.SaveRefreshTokenUseCase>(
      () => _i235.SaveRefreshTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.DeleteRefreshTokenUseCase>(
      () => _i235.DeleteRefreshTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.lazySingleton<_i235.RefreshTokenUseCase>(
      () => _i235.RefreshTokenUseCase(gh<_i536.AuthRepo>()),
    );
    gh.factory<_i560.AuthCubit>(
      () => _i560.AuthCubit(
        gh<_i856.LoginUsecase>(),
        gh<_i187.RegisterUsecase>(),
        gh<_i235.SaveAccessTokenUseCase>(),
        gh<_i235.SaveRefreshTokenUseCase>(),
      ),
    );
    gh.factory<_i384.MeCubit>(
      () => _i384.MeCubit(gh<_i911.GetCurrentUserUsecase>()),
    );
    gh.factory<_i725.LogOutCubit>(
      () => _i725.LogOutCubit(
        gh<_i235.DeleteAccessTokenUseCase>(),
        gh<_i235.DeleteRefreshTokenUseCase>(),
      ),
    );
    return this;
  }
}

class _$InjectableModules extends _i484.InjectableModules {}
