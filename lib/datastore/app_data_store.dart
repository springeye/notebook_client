import 'package:shared_preferences/shared_preferences.dart';

class AppDataStore {
  AppDataStore._privateConstructor();

  static final AppDataStore _instance = AppDataStore._privateConstructor();

  factory AppDataStore() {
    return _instance;
  }

  static AppDataStore of() {
    return AppDataStore();
  }

  Future<bool> getBool(String key, bool? defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(key);
    if (value == null) {
      return defaultValue ?? false;
    } else {
      return value;
    }
  }

  Future<String?> getString(String key, {String? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if (value == null) {
      return defaultValue;
    } else {
      return value;
    }
  }

  Future<int> getInt(String key, {int? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(key);
    if (value == null) {
      return defaultValue ?? 0;
    } else {
      return value;
    }
  }

  Future<bool> setBool(String key, {bool? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      return prefs.setBool(key, value);
    } else {
      return prefs.remove(key);
    }
  }

  Future<bool> setString(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      return prefs.setString(key, value);
    } else {
      return prefs.remove(key);
    }
  }

  Future<bool> setInt(String key, int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      return prefs.setInt(key, value);
    } else {
      return prefs.remove(key);
    }
  }
}
