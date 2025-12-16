import 'package:football/core/tokens/auth_tokens.dart';
import 'package:football/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences prefs;
  AuthLocalDatasourceImpl(this.prefs);
  @override
  Future<dynamic> saveToken(String token) async {
    return await prefs.setString(AuthTokens.accessToken, token);
  }

  @override
  Future<dynamic> getToken() async {
    return prefs.getString(AuthTokens.accessToken);
  }

  @override
  Future<dynamic> deleteToken() async {
    return await prefs.remove(AuthTokens.accessToken);
  }
}
