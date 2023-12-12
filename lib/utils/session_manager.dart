import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

class SessionManager {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyNamaUser = 'namaUser';
  static const String _keyDeptId = 'deptId';
  static const String _keyDeptFullName = 'deptFullName';
  static const String _keyDeptInisial = 'deptInisial';
  static const String _keyNoAbsen = 'noAbsen';
  static const String _themeKey = 'theme';
  static const Locale _languageKey = Locale('en', 'US');

  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal() {
    initPrefs();
  }

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> saveUserInfo(Map<String, dynamic> userData) async {
    await _prefs.setString(_keyUserId, userData['user_id']);
    await _prefs.setString(_keyNamaUser, userData['Nama_User']);
    await _prefs.setString(_keyDeptId, userData['DeptId']);
    await _prefs.setString(_keyDeptFullName, userData['DeptFullName']);
    await _prefs.setString(_keyDeptInisial, userData['DeptInisial']);
    await _prefs.setString(_keyNoAbsen, userData['NoAbsen']);
  }

  String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getNamaUser() {
    return _prefs.getString(_keyNamaUser);
  }

  String? getDeptId() {
    return _prefs.getString(_keyDeptId);
  }

  String? getDeptFullName() {
    return _prefs.getString(_keyDeptFullName);
  }

  String? getDeptInisial() {
    return _prefs.getString(_keyDeptInisial);
  }

  String? getNoAbsen() {
    return _prefs.getString(_keyNoAbsen);
  }

  String getTheme() {
    return _prefs.getString(_themeKey) ?? globalTheme;
  }

  Future<void> setTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  Locale getLanguage() {
    String storedLanguage = _prefs.getString(_languageKey.toString()) ?? globalLanguage.toString();
    List<String> languageParts = storedLanguage.split('_');
    return Locale(languageParts[0], languageParts.length > 1 ? languageParts[1] : '');
  }

  Future<void> setLanguage(Locale languageCode) async {
    await _prefs.setString(_languageKey.toString(), languageCode.toString());
  }

  void logout() {
    _prefs.remove(_keyUserId);
    _prefs.remove(_keyNamaUser);
    _prefs.remove(_keyDeptId);
    _prefs.remove(_keyDeptFullName);
    _prefs.remove(_keyDeptInisial);
    _prefs.remove(_keyNoAbsen);
    setLoggedIn(false);
  }
}
