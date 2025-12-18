import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/dialogs/loading_dialog.dart';
import 'package:football/core/navigation/app_route_constants.dart';
import 'package:football/features/auth/ui/auth_state.dart';
import 'package:football/features/auth/ui/auth_viewmodel.dart';
import 'package:football/features/auth/ui/components/auth_button.dart';
import 'package:football/features/auth/ui/components/custom_text_form_field.dart';
import 'package:football/features/auth/ui/components/login_button.dart';
import 'package:go_router/go_router.dart';

class RegisterScreenBody extends ConsumerStatefulWidget {
  const RegisterScreenBody(this.authViewmodel, this.authState, {super.key});

  final AuthViewmodel authViewmodel;
  final AuthState authState;

  @override
  ConsumerState<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends ConsumerState<RegisterScreenBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    "Create an account",
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // Username field
                CustomTextFormField(
                  controller: _fullNameController,
                  label: "username",
                  maxLength: 20, // ✅ Maximum 20 chars
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المستخدم';
                    } else if (value.trim().length < 5) {
                      return 'اسم المستخدم يجب أن يكون 5 أحرف على الأقل';
                    } else if (value.trim().length > 20) {
                      return 'اسم المستخدم يجب ألا يتجاوز 20 حرفًا';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                CustomTextFormField(
                  controller: _emailController,
                  label: "Email",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني بشكل صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextFormField(
                  controller: _passwordController,
                  label: "Password",
                  isPassword: true,
                  obscureText: _obscurePassword,
                  togglePasswordVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Register button
                AuthButton(
                  formKey: _formKey,
                  title: "Sign up",
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      LoadingDialog.show(context);

                      await widget.authViewmodel.register(
                        _fullNameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (widget.authViewmodel.state.isRegistered == false) {
                        LoadingDialog.hide(context);
                      } else {
                        LoadingDialog.hide(context);

                        context.goNamed(AppRouteConstants.home);
                      }
                    }
                  },
                ),

                const SizedBox(height: 16),

                Center(child: Login()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
