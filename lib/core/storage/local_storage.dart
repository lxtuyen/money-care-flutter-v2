import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ----------------- Basic methods -----------------

  Future<bool> writeString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? readString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? readInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? readBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // ----------------- Specialized methods -----------------

  static const String keyAccessToken = 'access_token';
  static const String keyUserInfo = 'user_info';

  Future<void> saveToken(String token) async {
    await writeString(keyAccessToken, token);
  }

  String? getToken() {
    return readString(keyAccessToken);
  }

  Future<void> saveUserInfo(Map<String, dynamic> apiRes) async {
    String jsonString = jsonEncode(apiRes);
    await writeString(keyUserInfo, jsonString);
  }

  Map<String, dynamic>? getUserInfo() {
    String? jsonString = readString(keyUserInfo);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> logout() async {
    await remove(keyAccessToken);
    await remove(keyUserInfo);
  }
}
