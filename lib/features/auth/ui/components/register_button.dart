import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:go_router/go_router.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.goNamed(AppRouteConstants.register);
      },
      child: Text(
        'Create an account',
        style: TextStyle(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
