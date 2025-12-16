import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.title,

    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primary,
      onPressed: onPressed,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
