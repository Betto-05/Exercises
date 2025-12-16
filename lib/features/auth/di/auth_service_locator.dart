import 'package:football/core/services/database/remote/database_remote_services_impl.dart';
import 'package:football/core/services/user/user_services.dart';
import 'package:football/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:football/features/auth/data/datasource/local/auth_local_datasource_impl.dart';
import 'package:football/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:football/features/auth/data/datasource/remote/auth_remote_datasource_impl.dart';
import 'package:football/features/auth/data/repo/auth_repo.dart';
import 'package:football/features/auth/data/repo/auth_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authLocator = GetIt.instance;

Future<void> setupAuthServiceLocator() async {
  authLocator.registerLazySingleton<AuthRemoteDatasource>(() {
    final databaseServices = DatabaseRemoteServicesImpl();
    return AuthRemoteDatasourceImpl(databaseRemoteServices: databaseServices);
  });

  authLocator.registerLazySingleton<UserService>(() => UserService());

  authLocator.registerLazySingletonAsync<AuthLocalDatasource>(() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthLocalDatasourceImpl(prefs);
  });

  await authLocator.isReady<AuthLocalDatasource>();

  authLocator.registerLazySingleton<AuthRepository>(() {
    final authRemoteDatasource = authLocator.get<AuthRemoteDatasource>();
    final authLocalDatasource = authLocator.get<AuthLocalDatasource>();
    return AuthRepoImpl(
      authLocalDatasource,
      authRemoteDatasource: authRemoteDatasource,
    );
  });
}
