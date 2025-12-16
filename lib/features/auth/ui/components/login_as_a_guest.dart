import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:go_router/go_router.dart';

class LoginAsAGuest extends StatelessWidget {
  const LoginAsAGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.goNamed(AppRouteConstants.home);
      },
      child: Text(
        "Enter as a Guest",
        style: TextStyle(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
