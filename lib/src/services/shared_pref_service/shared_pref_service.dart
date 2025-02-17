import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPref;

const _authTokenKey = "auth_token";

class PrefService {
  static Future<bool> setToken(String? token) {
    return token == null ? sharedPref.remove(_authTokenKey) : sharedPref.setString(_authTokenKey, token);
  }

  static String? getToken() => sharedPref.getString(_authTokenKey);
}
