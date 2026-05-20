import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';
import 'progress_big_card_bar.dart';
import 'progress_big_card_header.dart';

class ProgressBigCard extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  const ProgressBigCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  double get _progress =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  String get _percentLabel =>
      '${(_progress * 100).toStringAsFixed(0)}%';

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProgressBigCardHeader(),
          const SizedBox(height: AppSizes.sm),
          Text(_percentLabel, style: AppTextStyles.bigPercent),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.tasksCompleted(completedTasks, totalTasks),
            style: AppTextStyles.bigCardSub,
          ),
          const SizedBox(height: AppSizes.md),
          ProgressBigCardBar(progress: _progress),
        ],
      ),
    );
  }
}
