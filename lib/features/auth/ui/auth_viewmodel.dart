import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/models/user.dart';
import 'package:football/core/services/user/user_services.dart';
import 'package:football/core/utils/ui_state.dart';
import 'package:football/features/auth/di/auth_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthViewmodel extends StateNotifier<AuthState> {
  late final AuthRepository authRepository;
  late final UserService userService;
  Timer? _emailCheckTimer;
  bool _isDisposed = false;

  AuthViewmodel() : super(const AuthState(uiState: UiState.loading)) {
    _init();
  }

  Future<void> _init() async {
    authRepository = authLocator.get<AuthRepository>();
    userService = authLocator.get<UserService>();

    final localUser = await userService.loadUserFromLocal();

    if (localUser != null) {
      state = state.copyWith(
        uiState: UiState.data,
        isLoggedIn: true,
        user: localUser,
      );

      if (!localUser.isEmailVerified) {
        _startEmailVerificationWatcher();
      }
    } else {
      state = state.copyWith(uiState: UiState.data, isLoggedIn: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(uiState: UiState.loading);

    try {
      final user = await authRepository.login(email, password);
      if (user == null) throw Exception("Login failed");

      await _persistUser(user);

      state = state.copyWith(
        uiState: UiState.data,
        isLoggedIn: true,
        user: user,
      );

      if (!user.isEmailVerified) {
        _startEmailVerificationWatcher();
      }
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(uiState: UiState.loading);

    try {
      final user = await authRepository.register(
        email,
        password,
        name: name.trim(),
      );

      if (user == null) throw Exception("Registration failed");

      await _persistUser(user);

      state = state.copyWith(
        uiState: UiState.data,
        isRegistered: true,
        user: user,
      );

      _startEmailVerificationWatcher();
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  // ---------------- PASSWORD RESET ----------------
  Future<void> sendPasswordResetLink(String email) async {
    state = state.copyWith(uiState: UiState.loading);

    try {
      await authRepository.sendPasswordResetEmail(email);
      state = state.copyWith(uiState: UiState.data);
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  // ---------------- EMAIL VERIFICATION WATCHER ----------------
  void _startEmailVerificationWatcher() {
    _emailCheckTimer?.cancel();

    _emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isDisposed) return;

      final firebaseUser = await authRepository.getCurrentUser();
      if (firebaseUser == null) return;

      if (firebaseUser.isEmailVerified) {
        _emailCheckTimer?.cancel();

        final localUser = await userService.loadUserFromLocal();
        if (localUser == null) return;

        final updatedUser = localUser.copyWith(isEmailVerified: true);

        await _persistUser(updatedUser);
        await _createUserFirestoreDoc(updatedUser);

        if (!_isDisposed) {
          state = state.copyWith(user: updatedUser);
        }
      }
    });
  }

  // ---------------- HELPERS ----------------
  Future<void> _persistUser(AppUser user) async {
    userService.setUser(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("current_user", user.toJsonString());
  }

  Future<void> _createUserFirestoreDoc(AppUser user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "email": user.email,
      "name": user.name,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _emailCheckTimer?.cancel();
    super.dispose();
  }
}

final authViewmodelProvider =
    StateNotifierProvider.autoDispose<AuthViewmodel, AuthState>(
      (ref) => AuthViewmodel(),
    );
