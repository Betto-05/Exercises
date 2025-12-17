import 'package:flutter/material.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';
import 'package:football/features/auth/ui/forget_password_screen.dart';
import 'package:football/features/auth/ui/login_screen.dart';
import 'package:football/features/auth/ui/register_screen.dart';
import 'package:football/features/auth/ui/verify_email_screen.dart';
import 'package:football/features/home/ui/home_screen.dart';
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
      GoRoute(
        name: AppRouteConstants.login,
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: LoginScreen(),
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
      GoRoute(
        name: AppRouteConstants.register,
        path: '/register',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: RegisterScreen(),
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
      GoRoute(
        name: AppRouteConstants.validateEmailScreen,
        path: '/validate-email',
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: VerifyEmailScreen(authViewmodel: AuthViewmodel(), email),
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
      GoRoute(
        name: AppRouteConstants.forgetPassword,
        path: '/forget-password',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ForgetPasswordScreen(),
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
      GoRoute(
        name: AppRouteConstants.home,
        path: '/home',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: HomeScreen(),
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
