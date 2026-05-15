import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // ── Header ────────────────────────────────────────────────
  static const greetingSmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const greetingName = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  static const dateLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  // ── Cards / Sections ──────────────────────────────────────
  static const sectionTitle = TextStyle(
    fontSize: 15,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  static const cardLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );

  static const progressPercent = TextStyle(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );

  static const progressSub = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
    fontWeight: FontWeight.w400,
  );

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

  static const statNumber = TextStyle(
    fontSize: 28,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
  );

  static const statLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );

  static const emptyTitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );

  static const emptySubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
    fontWeight: FontWeight.w400,
  );

  // ── Modal ─────────────────────────────────────────────────
  static const modalTitle = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  static const fieldLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

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
  static const authTitle = TextStyle(
    fontSize: 24,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static const authSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const authTagline = TextStyle(
    fontSize: 11,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  static const authLink = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const authBodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const authTerms = TextStyle(
    fontSize: 11,
    color: AppColors.textHint,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
