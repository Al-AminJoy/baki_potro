import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String IMAGE_KEY = "image_key";
  static const String NAME_KEY = "name_key";
  static const String EMAIL_KEY = "email_key";
  static const String NUMBER_KEY = "number_key";
  static const String THEME_KEY = "theme_key";

  static Future<String> getFromPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }

  static Future<bool> saveToPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
