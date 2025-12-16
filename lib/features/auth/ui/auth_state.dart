import 'package:football/core/models/user.dart';
import 'package:football/core/utils/ui_state.dart'; // Ensure this exists

class AuthState {
  final UiState uiState;
  final bool isLoggedIn;
  final bool isRegistered;
  final String? errorMessage;
  final AppUser? user;

  const AuthState({
    required this.uiState,
    this.isLoggedIn = false,
    this.isRegistered = false,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    UiState? uiState,
    bool? isLoggedIn,
    bool? isRegistered,
    String? errorMessage,
    AppUser? user,
  }) {
    return AuthState(
      uiState: uiState ?? this.uiState,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isRegistered: isRegistered ?? this.isRegistered,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
