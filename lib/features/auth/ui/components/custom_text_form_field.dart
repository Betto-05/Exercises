import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool obscureText;
  final void Function()? togglePasswordVisibility;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.obscureText = false,
    this.togglePasswordVisibility,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? widget.obscureText : false,
      keyboardType: widget.keyboardType,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return ' الحقل مطلوب ';
            }
            return null;
          },
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,

      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon:
            widget.isPassword && widget.controller.text.isNotEmpty
                ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: widget.togglePasswordVisibility,
                )
                : null,
      ),
    );
  }
}
