import 'package:football/core/models/user.dart';

abstract class DatabaseRemoteServices {
  Future<AppUser?> login(String email, String password);
  Future<AppUser?> register(String email, String password, {String? name});
  Future<dynamic> logOut();
  Future<AppUser?> getCurrentUser();
}
