import 'package:flutter/material.dart';
import 'package:football/core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      toolbarHeight: 70,

      backgroundColor: AppColors.primary,
      elevation: 0,

      flexibleSpace: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ),

      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
