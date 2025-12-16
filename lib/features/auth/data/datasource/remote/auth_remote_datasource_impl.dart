import 'package:football/core/models/user.dart';
import 'package:football/core/services/database/remote/database_remote_services_impl.dart';
import 'package:football/features/auth/data/datasource/remote/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DatabaseRemoteServicesImpl databaseRemoteServices;

  AuthRemoteDatasourceImpl({required this.databaseRemoteServices});
  @override
  Future<AppUser?> login(String email, String password) {
    return databaseRemoteServices.login(email, password);
  }

  @override
  Future<AppUser?> register(String email, String password, String name) {
    return databaseRemoteServices.register(email, password, name: name);
  }

  @override
  Future<AppUser?> getCurrentUser() {
    return databaseRemoteServices.getCurrentUser();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return databaseRemoteServices.sendPasswordResetEmail(email);
  }
}
