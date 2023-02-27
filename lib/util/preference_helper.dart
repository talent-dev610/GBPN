
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static SharedPreferences? preferences;

  static Future<bool> clear() {
    return preferences!.clear();
  }

  static Future<bool> remove(String key) {
    return preferences!.remove(key);
  }

  static dynamic get(String key) {
    return preferences!.get(key);
  }

  static Set<String> getKeys() {
    return preferences!.getKeys();
  }

  static Future<bool> setBool(String key, bool value) {
    return preferences!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return preferences!.getBool(key);
  }

  static Future<bool> setDouble(String key, double value) {
    return preferences!.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return preferences!.getDouble(key);
  }

  static Future<bool> setInt(String key, int value) {
    return preferences!.setInt(key, value);
  }

  static int? getInt(String key) {
    return preferences!.getInt(key);
  }

  static Future<bool> setDate(String key, DateTime? value) {
    if (value == null) return preferences!.remove(key);
    int timestamp = value.millisecondsSinceEpoch;
    return preferences!.setInt(key, timestamp);
  }

  static DateTime? getDate(String key) {
    int? timestamp = preferences!.getInt(key);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  static Future<bool> setString(String key, String? value) {
    return preferences!.setString(key, value ?? "");
  }

  static String? getString(String key) {
    return preferences!.getString(key);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return preferences!.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return preferences!.getStringList(key) ?? [];
  }
  ///Singleton factory
  static final PreferenceHelper _instance = PreferenceHelper._internal();
  factory PreferenceHelper() {
    return _instance;
  }
  PreferenceHelper._internal();
}