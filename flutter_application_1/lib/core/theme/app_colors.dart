import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFFE8622A);
  static const primaryLight = Color(0xFFFFF3EE);
  static const primaryDisabled = Color(0xFFF0997B);

  // Neutral
  static const background = Color(0xFFF7F6F2);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E3DC);
  static const divider = Color(0xFFEDEBE4);

  // Text
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF888780);
  static const textHint = Color(0xFFBBB9B2);

  // Misc
  static const avatarBackground = Color(0xFFE8622A);
  static const avatarForeground = Color(0xFFFFFFFF);

  // Status / Admin
  static const danger = Color(0xFFE53935);
  static const dangerDark = Color(0xFFD32F2F);
  static const dangerLight = Color(0xFFFFEBEE);
  static const success = Color(0xFF43A047);
  static const successLight = Color(0xFFE8F5E9);
  static const info = Color(0xFF1E88E5);
  static const infoLight = Color(0xFFE3F2FD);
  static const muted = Color(0xFFF5F5F5);
  static const mutedText = Color(0xFF9E9E9E);

  static const List<Color> avatarPalette = [
    Color(0xFFE8622A),
    Color(0xFF1E88E5),
    Color(0xFF8E24AA),
    Color(0xFF43A047),
    Color(0xFF6D4C41),
  ];
}
