import 'package:flutter/material.dart';
import 'package:football/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import 'app_route_constants.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRouteConstants.splash,
        path: '/',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: SplashScreen(),
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(
        child: Scaffold(body: Center(child: Text("Error: Page not found!"))),
      );
    },
  );
}
