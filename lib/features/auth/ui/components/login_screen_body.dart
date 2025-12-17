import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/dialogs/loading_dialog.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';
import 'package:football/features/auth/ui/components/auth_button.dart';
import 'package:football/features/auth/ui/components/custom_text_form_field.dart';
import 'package:football/features/auth/ui/components/login_as_a_guest.dart';
import 'package:football/features/auth/ui/components/register_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends ConsumerStatefulWidget {
  const LoginScreenBody({super.key});

  @override
  ConsumerState<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends ConsumerState<LoginScreenBody> {
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthViewmodel authViewmodel;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    authViewmodel = ref.read(authViewmodelProvider.notifier);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailNotVerified(User firebaseUser) async {
    try {
      if (!firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
        if (mounted) context.pushNamed(AppRouteConstants.validateEmailScreen);
      }
    } catch (e) {
      print('Failed to send verification email: $e');
    }
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
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Sign in', style: TextStyle(fontSize: 24)),
                ),

                // Email field
                CustomTextFormField(
                  controller: _emailController,
                  label: 'Email',
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  togglePasswordVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(AppRouteConstants.forgetPassword);
                    },
                    child: const Text('Forget Password ?'),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                AuthButton(
                  formKey: _formKey,
                  title: 'Sign in ',
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    LoadingDialog.show(context);

                    try {
                      await authViewmodel.login(
                        _emailController.text,
                        _passwordController.text,
                      );

                      final user = authViewmodel.state.user;
                      final firebaseUser = FirebaseAuth.instance.currentUser;

                      // Hide keyboard first
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).unfocus();
                      });

                      if (authViewmodel.state.isLoggedIn && user != null) {
                        if (firebaseUser != null &&
                            firebaseUser.emailVerified) {
                          LoadingDialog.hide(context);
                          if (mounted) context.goNamed(AppRouteConstants.home);
                        } else if (firebaseUser != null) {
                          await _handleEmailNotVerified(firebaseUser);
                          LoadingDialog.hide(context);
                        } else {
                          LoadingDialog.hide(context);
                        }
                      } else {
                        LoadingDialog.hide(context);
                        if (mounted) {}
                      }
                    } catch (e) {
                      LoadingDialog.hide(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).unfocus();
                      });
                      if (mounted) {}
                    }
                  },
                ),

                const SizedBox(height: 16),

                const Center(child: Register()),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                const Center(child: LoginAsAGuest()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
