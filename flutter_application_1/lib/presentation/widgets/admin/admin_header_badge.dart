import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminHeaderBadge extends StatelessWidget {
  final String label;

  const AdminHeaderBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(label, style: AppTextStyles.adminBadge),
    );
  }
}
