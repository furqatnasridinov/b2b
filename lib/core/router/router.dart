import 'package:b2b_seller/core/utils/logger.dart';
import 'package:flutter/material.dart';
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

    ],
  );
}
