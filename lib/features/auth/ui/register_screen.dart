import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/constants/images.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';
import 'package:football/features/auth/ui/components/register_screen_body.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final Color startColor = AppColors.primary;
  final Color endColor = AppColors.primary.withOpacity(0.3);
  late AuthViewmodel authViewmodel;

  @override
  void initState() {
    super.initState();
    authViewmodel = ref.read(authViewmodelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(authViewmodelProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: AppColors.primary),
          RegisterScreenBody(authViewmodel, state),
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
