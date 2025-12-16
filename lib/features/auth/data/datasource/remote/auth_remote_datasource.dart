import 'package:football/core/models/user.dart';

abstract class AuthRemoteDatasource {
  Future<AppUser?> login(String email, String password);
  Future<AppUser?> register(String email, String password, String name);
  Future<void> sendPasswordResetEmail(String email);
  Future<AppUser?> getCurrentUser();
}
