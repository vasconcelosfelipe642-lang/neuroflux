import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class TaskListEmpty extends StatelessWidget {
  const TaskListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.noTasksTitle, style: AppTextStyles.emptyTitle),
          const SizedBox(height: AppSizes.xs),
          Text(AppStrings.noTasksSubtitle, style: AppTextStyles.emptySubtitle),
        ],
      ),
    );
  }
}
