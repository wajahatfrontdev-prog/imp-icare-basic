import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Save user data
  static Future<void> saveUserData(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(userJson));
  }

  // Get user data
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  // Save login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  // Get login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyIsLoggedIn);
  }
}
