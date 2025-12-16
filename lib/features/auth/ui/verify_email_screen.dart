import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/constants/images.dart';
import 'package:football/core/utils/ui_state.dart';
import 'package:football/features/auth/ui/auth_state.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final AuthViewmodel authViewmodel;
  final String email;

  const VerifyEmailScreen(this.email, {super.key, required this.authViewmodel});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    // Start sending verification email and auto-check

    widget.authViewmodel.startAutoEmailCheck();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewmodelProvider);

    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.user?.isEmailVerified == true) {
        if (mounted) {
          Navigator.pushNamed(context, 'home');
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: AppColors.primary),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "تأكيد البريد الإلكتروني",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "لقد أرسلنا رابط تحقق إلى بريدك الإلكتروني.\n${widget.email} \n"
                    "الرجاء التحقق من البريد الوارد أو مجلد الرسائل غير المرغوب فيه (Spam).",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (state.uiState == UiState.loading)
                    const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 32),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(AppImages.logo, scale: 5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
