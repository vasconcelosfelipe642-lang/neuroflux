import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
          const SizedBox(height: AppSizes.sm),
          Text('$count', style: AppTextStyles.statNumber),
          const SizedBox(height: AppSizes.xs),
          Text(label, style: AppTextStyles.statLabel),
        ],
      ),
    );
  }
}
