import 'package:football/core/models/user.dart';
import 'package:football/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:football/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:football/features/auth/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepoImpl(this.authLocalDatasource, {required this.authRemoteDatasource});

  @override
  Future<AppUser?> login(String email, String password) {
    return authRemoteDatasource.login(email, password);
  }

  @override
  Future<AppUser?> register(String email, String password, {String? name}) {
    return authRemoteDatasource.register(email, password, name!);
  }

  @override
  Future<dynamic> getToken() {
    return authLocalDatasource.getToken();
  }

  @override
  Future<dynamic> saveToken(String token) {
    return authLocalDatasource.saveToken(token);
  }

  @override
  Future<dynamic> deleteToken() {
    return authLocalDatasource.deleteToken();
  }

  @override
  Future<AppUser?> getCurrentUser() {
    return authRemoteDatasource.getCurrentUser();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return authRemoteDatasource.sendPasswordResetEmail(email);
  }
}
