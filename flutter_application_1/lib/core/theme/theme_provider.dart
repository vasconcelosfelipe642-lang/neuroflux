import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_sizes.dart';

/// Gerencia tema claro/escuro com persistência em [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  ThemeProvider._();
  static final instance = ThemeProvider._();

  static const _themePrefKey = 'theme_is_dark';
  static const _fontScalePrefKey = 'font_scale';
  static const double _defaultFontScale = AppSizes.fontScale;

  bool _isDark = false;
  bool _initialized = false;
  double _fontScale = _defaultFontScale;

  bool get isDark => _isDark;
  bool get isInitialized => _initialized;
  double get fontScale => _fontScale;
  bool get canIncreaseFont => _fontScale < 1.4;
  bool get canDecreaseFont => _fontScale > 0.9;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themePrefKey) ?? false;
    _fontScale = prefs.getDouble(_fontScalePrefKey) ?? _defaultFontScale;
    _initialized = true;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, _isDark);
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, _isDark);
  }

  Future<void> setFontScale(double value) async {
    final nextScale = value.clamp(0.9, 1.4);
    if ((nextScale - _fontScale).abs() < 0.0001) return;

    _fontScale = double.parse(nextScale.toStringAsFixed(1));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScalePrefKey, _fontScale);
  }

  Future<void> changeFontScale(double delta) async {
    await setFontScale(_fontScale + delta);
  }
}
