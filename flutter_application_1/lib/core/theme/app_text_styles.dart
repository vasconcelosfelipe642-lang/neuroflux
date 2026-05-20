import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // ── Header ────────────────────────────────────────────────
  static TextStyle get greetingSmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get greetingName => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get dateLabel => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textSecondary);

  // ── Cards / Sections ──────────────────────────────────────
  static TextStyle get sectionTitle => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get cardLabel => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ).copyWith(color: AppColors.textSecondary);

  static const progressPercent = TextStyle(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get progressSub => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textHint);

  static const bigPercent = TextStyle(
    fontSize: 48,
    color: Colors.white,
    fontWeight: FontWeight.w800,
    height: 1.1,
  );

  static const bigCardTitle = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const bigCardSub = TextStyle(
    fontSize: 13,
    color: Colors.white70,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get statNumber => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get statLabel => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get emptyTitle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get emptySubtitle => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textHint);

  // ── Modal ─────────────────────────────────────────────────
  static TextStyle get modalTitle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get fieldLabel => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ).copyWith(color: AppColors.textPrimary);

  // ── Nav / Buttons ─────────────────────────────────────────
  static const navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const fabLabel = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // ── Auth ──────────────────────────────────────────────────
  static TextStyle get authTitle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.2,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get authSubtitle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get authTagline => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ).copyWith(color: AppColors.textSecondary);

  static const authLink = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get authBodySmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get authTerms => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ).copyWith(color: AppColors.textHint);

  // ── Admin ─────────────────────────────────────────────────
  static TextStyle get adminPanelLabel => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get adminTitle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get adminScreenTitle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ).copyWith(color: AppColors.textPrimary);

  static const adminBadge = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get adminStatNumber => const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get adminStatLabel => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ).copyWith(color: AppColors.textSecondary);

  static TextStyle get adminUserName => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get adminUserMeta => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: AppColors.textSecondary);

  static const adminLink = TextStyle(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const adminDangerButton = TextStyle(
    fontSize: 13,
    color: AppColors.dangerDark,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get adminModalTitle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ).copyWith(color: AppColors.textPrimary);

  static TextStyle get adminModalBody => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ).copyWith(color: AppColors.textSecondary);

  static const adminHighlightPercent = TextStyle(
    fontSize: 26,
    color: AppColors.primary,
    fontWeight: FontWeight.w800,
  );

  static const adminStatusActive = TextStyle(
    fontSize: 12,
    color: AppColors.success,
    fontWeight: FontWeight.w600,
  );

  static const adminStatusBanned = TextStyle(
    fontSize: 12,
    color: AppColors.mutedText,
    fontWeight: FontWeight.w600,
  );
}
