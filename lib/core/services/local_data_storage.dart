import 'package:shared_preferences/shared_preferences.dart';



class LocalDataStorage {
  LocalDataStorage._();
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // clear all data
  static Future<void> clear() async {
    await _preferences?.clear();
  }

  static Future<void> setString(String key, String value) async {
      await _preferences?.setString(key, value);
  }

  static String getString(String key) {
    return _preferences?.getString(key) ?? '';
  }

  static Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences?.getInt(key) ?? 0;
  }

  static Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static bool getBool(String key) {
    return _preferences?.getBool(key) ?? false;
  }
}

//keys for prefs
class LocalDataStorageKeys {
  LocalDataStorageKeys._();

  static const String isDarkMode = 'isDarkMode';
  static const String locale = 'locale';
}
