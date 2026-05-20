import 'package:flutter/material.dart';
import 'theme_provider.dart';

abstract final class AppColors {
  static const primary = Color(0xFFE8622A);
  static const primaryLight = Color(0xFFFFF3EE);
  static const primaryDisabled = Color(0xFFF0997B);

  static const _backgroundLight = Color(0xFFF7F6F2);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _borderLight = Color(0xFFE5E3DC);
  static const _dividerLight = Color(0xFFEDEBE4);
  static const _textPrimaryLight = Color(0xFF1A1A1A);
  static const _textSecondaryLight = Color(0xFF888780);
  static const _textHintLight = Color(0xFFBBB9B2);
  static const _inputFillLight = Color(0xFFFAFAF8);
  static const _mutedLight = Color(0xFFF5F5F5);
  static const _dangerLightLight = Color(0xFFFFEBEE);
  static const _successLightLight = Color(0xFFE8F5E9);
  static const _infoLightLight = Color(0xFFE3F2FD);

  static const _backgroundDark = Color(0xFF1A1A2E);
  static const _surfaceDark = Color(0xFF16213E);
  static const _borderDark = Color(0xFF2A3A5C);
  static const _dividerDark = Color(0xFF243352);
  static const _textPrimaryDark = Color(0xFFF0F0F5);
  static const _textSecondaryDark = Color(0xFFA8B0C8);
  static const _textHintDark = Color(0xFF6B7590);
  static const _inputFillDark = Color(0xFF1E2D4A);
  static const _primaryLightDark = Color(0xFF3D2A22);
  static const _mutedDark = Color(0xFF1E2D4A);
  static const _dangerLightDark = Color(0xFF3D2224);
  static const _successLightDark = Color(0xFF1E3324);
  static const _infoLightDark = Color(0xFF1A2840);

  static bool get _isDark => ThemeProvider.instance.isDark;

  static Color get background => _isDark ? _backgroundDark : _backgroundLight;
  static Color get surface => _isDark ? _surfaceDark : _surfaceLight;
  static Color get border => _isDark ? _borderDark : _borderLight;
  static Color get divider => _isDark ? _dividerDark : _dividerLight;
  static Color get textPrimary => _isDark ? _textPrimaryDark : _textPrimaryLight;
  static Color get textSecondary =>
      _isDark ? _textSecondaryDark : _textSecondaryLight;
  static Color get textHint => _isDark ? _textHintDark : _textHintLight;
  static Color get inputFill => _isDark ? _inputFillDark : _inputFillLight;
  static Color get primaryLightTint =>
      _isDark ? _primaryLightDark : primaryLight;
  static Color get muted => _isDark ? _mutedDark : _mutedLight;
  static Color get dangerLight => _isDark ? _dangerLightDark : _dangerLightLight;
  static Color get successLight =>
      _isDark ? _successLightDark : _successLightLight;
  static Color get infoLight => _isDark ? _infoLightDark : _infoLightLight;

  static const avatarBackground = Color(0xFFE8622A);
  static const avatarForeground = Color(0xFFFFFFFF);

  static const danger = Color(0xFFE53935);
  static const dangerDark = Color(0xFFD32F2F);
  static const success = Color(0xFF43A047);
  static const info = Color(0xFF1E88E5);
  static const mutedText = Color(0xFF9E9E9E);

  static const List<Color> avatarPalette = [
    Color(0xFFE8622A),
    Color(0xFF1E88E5),
    Color(0xFF8E24AA),
    Color(0xFF43A047),
    Color(0xFF6D4C41),
  ];
}
