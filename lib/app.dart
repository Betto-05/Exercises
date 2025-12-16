import 'package:flutter/material.dart';
import 'package:football/features/splash/splash_screen.dart';

class Football extends StatelessWidget {
  const Football({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
