import 'package:football/core/models/user.dart';

abstract class AuthRepository {
  Future<AppUser?> login(String email, String password);
  Future<AppUser?> register(String email, String password, {String? name});
  Future<dynamic> saveToken(String token);
  Future<dynamic> getToken();
  Future<dynamic> deleteToken();
  Future<AppUser?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
}
