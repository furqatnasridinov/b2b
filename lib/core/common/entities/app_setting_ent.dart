import 'package:equatable/equatable.dart';

class AppSettingEntity extends Equatable {
  const AppSettingEntity({
    required this.isDarkTheme,
    required this.locale,
  });

  final bool isDarkTheme;
  final String locale;


  @override
  List<Object?> get props => [isDarkTheme, locale];
}
