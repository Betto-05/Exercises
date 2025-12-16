import 'package:football/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  AppUser? _user;

  /// Set user and save locally
  void setUser(AppUser user) {
    _user = user;
    saveUserToLocal(user);
  }

  /// Get current user
  AppUser? getUser() => _user;

  /// Save user to local storage
  Future<void> saveUserToLocal(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', user.toJsonString());
    prefs.setBool('is_email_verified', user.isEmailVerified);
  }

  Future<AppUser?> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('current_user');
    if (jsonString != null) {
      _user = AppUser.fromJsonString(jsonString);

      // Load isEmailVerified flag
      final isVerified = prefs.getBool('is_email_verified') ?? false;
      _user = _user!.copyWith(isEmailVerified: isVerified);

      return _user;
    }
    return null;
  }

  Future<void> clearUser() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('is_email_verified');
  }
}
