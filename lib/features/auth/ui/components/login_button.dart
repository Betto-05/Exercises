import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.goNamed(AppRouteConstants.login);
      },
      child: Text(
        "You have an account? Sign in",
        style: TextStyle(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
