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

  static const String keyAccessToken = 'access_token';
  static const String keyUserInfo = 'user_info';
  static const String keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const String keyIsBalanceVisible = 'is_balance_visible';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyLocale = 'app_locale';
  static const String keyStartDayOfMonth = 'start_day_of_month';
  static const String keyDashboardSections = 'dashboard_sections';

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

  Future<void> saveOnboardingSeen() async {
    await writeBool(keyHasSeenOnboarding, true);
  }

  bool hasSeenOnboarding() {
    return readBool(keyHasSeenOnboarding) ?? false;
  }

  String _onboardingDoneKey(int userId) => 'onboarding_done_$userId';

  Future<void> setOnboardingDone(int userId) async {
    await writeBool(_onboardingDoneKey(userId), true);
  }

  bool isOnboardingDone(int userId) {
    return readBool(_onboardingDoneKey(userId)) ?? false;
  }

  Future<void> saveBalanceVisibility(bool isVisible) async {
    await writeBool(keyIsBalanceVisible, isVisible);
  }

  bool getBalanceVisibility() {
    return readBool(keyIsBalanceVisible) ?? true;
  }

  Future<void> saveDarkMode(bool isDark) async {
    await writeBool(keyIsDarkMode, isDark);
  }

  bool getDarkMode() {
    return readBool(keyIsDarkMode) ?? false;
  }

  Future<void> saveLocale(String localeCode) async {
    await writeString(keyLocale, localeCode);
  }

  String getLocale() {
    return readString(keyLocale) ?? 'vi_VN';
  }

  Future<void> saveStartDayOfMonth(int day) async {
    await writeInt(keyStartDayOfMonth, day);
  }

  int getStartDayOfMonth() {
    return readInt(keyStartDayOfMonth) ?? 1;
  }

  Future<void> saveDashboardSections(List<String> sections) async {
    await writeString(keyDashboardSections, jsonEncode(sections));
  }

  List<String>? getDashboardSections() {
    String? json = readString(keyDashboardSections);
    if (json == null) return null;
    return List<String>.from(jsonDecode(json));
  }
}
