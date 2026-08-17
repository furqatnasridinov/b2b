// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:b2b_seller/core/common/bloc/app_settings_cubit.dart'
    as _i86;
import 'package:b2b_seller/core/injection/modules/injectable_modules.dart'
    as _i427;
import 'package:dio/dio.dart' as _i361;
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
    gh.factory<_i86.AppSettingsCubit>(() => _i86.AppSettingsCubit());
    gh.lazySingleton<_i361.Dio>(() => injectableModules.dio);
    return this;
  }
}

class _$InjectableModules extends _i427.InjectableModules {}
