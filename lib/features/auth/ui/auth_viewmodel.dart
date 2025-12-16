import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // THIS IMPORT FIXES 'state' & 'StateNotifierProvider'
import 'package:football/core/models/user.dart';
import 'package:football/core/services/user/user_services.dart';
import 'package:football/core/tokens/auth_tokens.dart';
import 'package:football/core/utils/ui_state.dart';
import 'package:football/features/auth/di/auth_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthViewmodel extends StateNotifier<AuthState> {
  // We use late variables, but initialized in init()
  late final AuthRepository authRepository;
  late final UserService userService;
  Timer? _emailCheckTimer;

  // Constructor passes initial state to super
  AuthViewmodel() : super(const AuthState(uiState: UiState.loading)) {
    init();
  }

  Future<void> init() async {
    authRepository = authLocator.get<AuthRepository>();
    userService = authLocator.get<UserService>();

    final localUser = await userService.loadUserFromLocal();
    if (localUser != null) {
      // 'state' is available because we extend StateNotifier
      state = state.copyWith(
        uiState: UiState.data,
        isLoggedIn: true,
        user: localUser,
      );

      if (!localUser.isEmailVerified) startAutoEmailCheck();
    } else {
      state = state.copyWith(uiState: UiState.data, isLoggedIn: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(uiState: UiState.loading);

    try {
      AppUser? firebaseUser = await authRepository.login(email, password);
      if (firebaseUser == null) throw Exception("فشل تسجيل الدخول");

      userService.setUser(firebaseUser);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("current_user", firebaseUser.toJsonString());

      state = state.copyWith(
        uiState: UiState.data,
        isLoggedIn: true,
        user: firebaseUser,
      );

      if (!firebaseUser.isEmailVerified) startAutoEmailCheck();
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        isLoggedIn: false,
        errorMessage: "فشل تسجيل الدخول: ${e.toString()}",
      );
    }
  }


  Future<void> register(
    String email,
    String password, {
    String? displayName,
  }) async {
    state = state.copyWith(uiState: UiState.loading);

    try {
      final username =
          (displayName?.isNotEmpty ?? false)
              ? displayName!.trim().toLowerCase()
              : email.split("@")[0].toLowerCase();

      final user = await authRepository.register(
        email,
        password,
        name: username,
      );
      if (user == null) throw Exception("فشل التسجيل");

      userService.setUser(user);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("current_user", user.toJsonString());
      await saveToken();

      state = state.copyWith(
        uiState: UiState.data,
        isRegistered: true,
        user: user,
      );

      if (!user.isEmailVerified) startAutoEmailCheck();
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        isRegistered: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> saveToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthTokens.accessToken, AuthTokens.accessToken);
  }

  // ---------------------------------------------------
  // EMAIL CHECK
  // ---------------------------------------------------
  void startAutoEmailCheck() {
    _emailCheckTimer?.cancel();
    _emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      // 1. Get local user to preserve existing data
      final currentUser = await userService.loadUserFromLocal();
      if (currentUser == null) {
        timer.cancel();
        return;
      }

      // 2. Check Firebase status
      final firebaseUser = await authRepository.getCurrentUser();
      if (firebaseUser == null) return;

      if (firebaseUser.isEmailVerified) {
        timer.cancel();

        final updated = currentUser.copyWith(isEmailVerified: true);
        userService.setUser(updated);

        // Check if mounted to prevent calling state after dispose
        if (mounted) {
          state = state.copyWith(user: updated);
        }

        await createUserDocumentAfterVerification(updated);
      }
    });
  }

  Future<void> createUserDocumentAfterVerification(AppUser user) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final username = user.name!.toLowerCase();
      final docId = "${user.email!.toLowerCase()}_$username";

      final userRef = firestore.collection("users").doc(docId);

      // Using set with merge to be safe
      await userRef.set({
        "email": user.email,
        "username": username,
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error creating user doc: $e");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
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

  @override
  void dispose() {
    _emailCheckTimer?.cancel();
    super.dispose();
  }
}
final authViewmodelProvider =
    StateNotifierProvider.autoDispose<AuthViewmodel, AuthState>(
      (ref) => AuthViewmodel(),
    );
