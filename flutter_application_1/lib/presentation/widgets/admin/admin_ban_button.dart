import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminBanButton extends StatelessWidget {
  final VoidCallback onTap;

  const AdminBanButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.dangerLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Text(AppStrings.adminBan, style: AppTextStyles.adminDangerButton),
      ),
    );
  }
}
