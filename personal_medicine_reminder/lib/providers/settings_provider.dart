import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';

/// Settings Provider
/// 
/// Implements SRS 2.12 - Settings & Preferences
/// Manages app theme, notification settings, and timezone
class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _notificationStyle = 'large'; // large or standard
  String _notificationSound = 'default';
  bool _autoTimezone = true;
  String? _timezone;
  bool _isInitialized = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get notificationStyle => _notificationStyle;
  String get notificationSound => _notificationSound;
  bool get autoTimezone => _autoTimezone;
  String? get timezone => _timezone;
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize settings from storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme - SRS 2.12.1 (SRS-139)
      final themeString = prefs.getString(AppConstants.themeKey);
      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == themeString,
          orElse: () => ThemeMode.system,
        );
      }

      // Load notification settings - SRS 2.12.2
      _notificationStyle = prefs.getString(AppConstants.notificationStyleKey) ?? 'large';
      _notificationSound = prefs.getString(AppConstants.notificationSoundKey) ?? 'default';

      // Load timezone settings - SRS 2.12.3
      _autoTimezone = prefs.getBool('auto_timezone') ?? true;
      _timezone = prefs.getString(AppConstants.timezoneKey);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing settings: $e');
    }
  }

  /// Toggle theme - SRS 2.12.1 (SRS-138)
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  /// Save theme to storage - SRS 2.12.1 (SRS-139)
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.themeKey, _themeMode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Set notification style - SRS 2.12.2 (SRS-140)
  Future<void> setNotificationStyle(String style) async {
    _notificationStyle = style;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.notificationStyleKey, style);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving notification style: $e');
    }
  }

  /// Set notification sound - SRS 2.12.2 (SRS-142)
  Future<void> setNotificationSound(String sound) async {
    _notificationSound = sound;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.notificationSoundKey, sound);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving notification sound: $e');
    }
  }

  /// Set auto timezone - SRS 2.12.3 (SRS-143)
  Future<void> setAutoTimezone(bool auto) async {
    _autoTimezone = auto;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_timezone', auto);
      
      if (auto) {
        // Detect device timezone - SRS 2.12.3 (SRS-143)
        _timezone = DateTime.now().timeZoneName;
        await prefs.setString(AppConstants.timezoneKey, _timezone!);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving timezone settings: $e');
    }
  }

  /// Set manual timezone
  Future<void> setTimezone(String timezone) async {
    _timezone = timezone;
    _autoTimezone = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.timezoneKey, timezone);
      await prefs.setBool('auto_timezone', false);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving timezone: $e');
    }
  }

  /// Get current timezone
  String getCurrentTimezone() {
    if (_autoTimezone) {
      return DateTime.now().timeZoneName;
    }
    return _timezone ?? DateTime.now().timeZoneName;
  }
}
