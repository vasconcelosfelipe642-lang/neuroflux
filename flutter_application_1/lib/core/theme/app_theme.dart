import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffoldBg: const Color(0xFFF7F6F2),
        surface: const Color(0xFFFFFFFF),
        border: const Color(0xFFE5E3DC),
        divider: const Color(0xFFEDEBE4),
        onSurface: const Color(0xFF1A1A1A),
        hint: const Color(0xFFBBB9B2),
        inputFill: const Color(0xFFFAFAF8),
        muted: const Color(0xFFF5F5F5),
        overlayStyle: SystemUiOverlayStyle.dark,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffoldBg: const Color(0xFF1A1A2E),
        surface: const Color(0xFF16213E),
        border: const Color(0xFF2A3A5C),
        divider: const Color(0xFF243352),
        onSurface: const Color(0xFFF0F0F5),
        hint: const Color(0xFF6B7590),
        inputFill: const Color(0xFF1E2D4A),
        muted: const Color(0xFF1E2D4A),
        overlayStyle: SystemUiOverlayStyle.light,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffoldBg,
    required Color surface,
    required Color border,
    required Color divider,
    required Color onSurface,
    required Color hint,
    required Color inputFill,
    required Color muted,
    required SystemUiOverlayStyle overlayStyle,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      cardColor: surface,
      dividerColor: divider,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primary,
        onSecondary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: overlayStyle,
        foregroundColor: onSurface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: TextStyle(fontSize: 14, color: hint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primaryDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF243352)
            : const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: onSurface,
        textColor: onSurface,
      ),
    );
  }
}
