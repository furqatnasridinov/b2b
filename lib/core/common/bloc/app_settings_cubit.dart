
import 'package:b2b_seller/core/common/entities/entities.dart';
import 'package:b2b_seller/core/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppSettingsCubit extends Cubit<AppSettingEntity> {
  AppSettingsCubit() : super (_init());

  static AppSettingEntity _init() {
    return AppSettingEntity(
      locale: LocalDataStorage.getString(LocalDataStorageKeys.locale),
      isDarkTheme: LocalDataStorage.getBool(LocalDataStorageKeys.isDarkMode),
    );
  }


  //set new themeMode
  Future<void> setIsDarkThemeState({
    required bool valueIsDarkTheme,
  }) async {
    //change themeMode state
    emit(
      AppSettingEntity(
        isDarkTheme: valueIsDarkTheme,
        locale: state.locale,
      ),
    );
    //add selected theme to local storage
    await LocalDataStorage.setBool(
      LocalDataStorageKeys.isDarkMode,
      valueIsDarkTheme,
    );
  }
}