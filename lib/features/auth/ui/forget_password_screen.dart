import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/constants/images.dart';
import 'package:football/core/dialogs/loading_dialog.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:football/core/utils/ui_state.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';
import 'package:football/features/auth/ui/components/auth_button.dart';
import 'package:football/features/auth/ui/components/custom_text_form_field.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: AppColors.primary),
          const ForgetPasswordScreenBody(),
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

class ForgetPasswordScreenBody extends ConsumerStatefulWidget {
  const ForgetPasswordScreenBody({super.key});

  @override
  ConsumerState<ForgetPasswordScreenBody> createState() =>
      _ForgetPasswordScreenBodyState();
}

class _ForgetPasswordScreenBodyState
    extends ConsumerState<ForgetPasswordScreenBody> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthViewmodel authViewmodel;

  @override
  void initState() {
    super.initState();
    authViewmodel = ref.read(authViewmodelProvider.notifier);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(authViewmodelProvider);

    return Align(
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'لا تقلق! أدخل بريدك الإلكتروني المسجل وسنرسل لك رابط لإعادة تعيين كلمة المرور.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال بريدك الإلكتروني';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'الرجاء إدخال بريد إلكتروني صالح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'تأكد من أن البريد الإلكتروني الذي أدخلته مسجل لدينا حتى تتمكن من استعادة حسابك بسهولة.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                AuthButton(
                  formKey: _formKey,
                  title: 'إستعادة حسابي',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      LoadingDialog.show(context);
                      await authViewmodel.sendPasswordResetEmail(
                        _emailController.text.trim(),
                      );
                      LoadingDialog.hide(context);

                      if (authViewmodel.state.uiState == UiState.data) {
                        context.goNamed(AppRouteConstants.login);
                      } else {}
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تذكرت كلمة المرور؟'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('تسجيل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
