import 'package:b2b_seller/bootstrap.dart';
import 'package:b2b_seller/core/common/bloc/app_settings_cubit.dart';
import 'package:b2b_seller/core/common/entities/entities.dart';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/router/router.dart';
import 'package:b2b_seller/core/services/app_constants.dart';
import 'package:b2b_seller/core/utils/themes/dark_theme.dart';
import 'package:b2b_seller/core/utils/themes/light_theme.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await bootstrap(() => const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //bloc for app setting
        BlocProvider(create: (context) => sl<AppSettingsCubit>()),
        BlocProvider(create: (context) => sl<MeCubit>()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingEntity>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.routerConfig,
            theme: state.isDarkTheme ? darkTheme : lightTheme
          );
        },
      ),
    );
  }
}
