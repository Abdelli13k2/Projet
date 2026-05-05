import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingViewModel extends ChangeNotifier {
  bool _isDark = false;
  bool _isInitialized = false;

  bool get isDark => _isDark;
  bool get isInitialized => _isInitialized;

  SettingViewModel() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('is_dark_mode') ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDark);
  }
}
