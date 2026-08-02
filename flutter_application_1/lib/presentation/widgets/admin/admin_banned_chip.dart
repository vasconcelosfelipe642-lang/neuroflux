import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminBannedChip extends StatelessWidget {
  const AdminBannedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      
      child: const Text(
        AppStrings.adminBanned,
        style: AppTextStyles.adminStatusBanned,
      ),
    );
  }
}
