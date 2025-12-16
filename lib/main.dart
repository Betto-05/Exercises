import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/app.dart';
import 'package:football/features/auth/di/auth_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupAuthServiceLocator();
  runApp(ProviderScope(child: const Fitness()));
}
