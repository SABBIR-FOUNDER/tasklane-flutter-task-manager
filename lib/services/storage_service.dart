import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _tokenKey,
      token,
    );
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _tokenKey,
    );
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.trim().isNotEmpty;
  }

  static Future<void> removeToken() async {
    await clearToken();
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _tokenKey,
    );
  }
}
