import 'package:b2b_seller/core/common/screens/base_url_settings.dart';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/utils/logger.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/health_check/health_check_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:b2b_seller/src/auth/presentation/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:b2b_seller/core/common/screens/screens.dart';

part 'observer.router.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

//handle deep link in exception go router
void handleDeepLinkException(
  BuildContext context,
  GoRouterState state,
  GoRouter router,
) {
  //temporary go to splash screen if deep link
  //router.go(SplashAnimatedScreen.path);
}

class AppRouter {
  static final routerConfig = GoRouter(
    onException: handleDeepLinkException,
    //extraCodec: EntityCodec(),
    observers: [
      RouterObserver(),
    ],
    initialLocation: SplashScreen.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      //splash screen
      GoRoute(
        path: SplashScreen.path,
        name: SplashScreen.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashScreen()),
      ),

      GoRoute(
        path: LoginScreen.path,
        name: LoginScreen.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        ),
      ),

      GoRoute(
        path: RegisterScreen.path,
        name: RegisterScreen.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        ),
      ),

      GoRoute(
        path: MainScreen.path,
        name: MainScreen.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainScreen()),
      ),

      GoRoute(
        path: ErrorScreen.path,
        name: ErrorScreen.name,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final message = extra is String ? extra : null;
          return NoTransitionPage(
            child: ErrorScreen(message: message),
          );
        },
      ),

      //settings screen
      GoRoute(
        path: ThemeSettingsScreen.path,
        name: ThemeSettingsScreen.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ThemeSettingsScreen()),
      ),

      GoRoute(
        path: SnackbarCustomizationScreen.path,
        name: SnackbarCustomizationScreen.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SnackbarCustomizationScreen()),
      ),

      GoRoute(
        path: BaseUrlSettingsScreen.path,
        name: BaseUrlSettingsScreen.name,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final navigatePathAfterSuccess =
              extra?['navigatePathAfterSuccess'] as String?;
          return NoTransitionPage(
            child: BlocProvider(
              create: (context) => sl<HealthCheckCubit>(),
              child: BaseUrlSettingsScreen(
                navigatePathAfterSuccess: navigatePathAfterSuccess,
              ),
            ),
          );
        },
      ),
    ],
  );
}
