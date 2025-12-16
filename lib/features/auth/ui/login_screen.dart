import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/constants/images.dart';
import 'package:football/features/auth/ui/components/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: AppColors.primary),
          LoginScreenBody(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.13,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(AppImages.logo, scale: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
