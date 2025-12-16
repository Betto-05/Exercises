abstract class AuthLocalDatasource {
  Future<dynamic> saveToken(String token);
  Future<dynamic> getToken();
  Future<dynamic> deleteToken();
}
