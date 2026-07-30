import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_scope.dart';

class AdminStatBox extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const AdminStatBox({
    super.key,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSizes.lg, horizontal: AppSizes.sm),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: highlight
                  ? AppTextStyles.adminHighlightPercent.copyWith(
                      color: Colors.white,
                    )
                  : AppTextStyles.adminStatNumber.copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: highlight
                ? AppTextStyles.adminStatLabel.copyWith(color: Colors.white70)
                : AppTextStyles.adminStatLabel,
          ),
        ],
      ),
    );
  }
}
