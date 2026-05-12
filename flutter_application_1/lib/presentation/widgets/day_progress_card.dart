import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class DayProgressCard extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  const DayProgressCard({
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
          _ProgressHeader(percentLabel: _percentLabel),
          const SizedBox(height: AppSizes.md),
          _ProgressBar(progress: _progress),
          const SizedBox(height: AppSizes.sm),
          Text(
            AppStrings.tasksCompleted(completedTasks, totalTasks),
            style: AppTextStyles.progressSub,
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final String percentLabel;

  const _ProgressHeader({required this.percentLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.dayProgress, style: AppTextStyles.cardLabel),
        Text(percentLabel, style: AppTextStyles.progressPercent),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: AppSizes.progressBarHeight,
        backgroundColor: AppColors.divider,
        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
      ),
    );
  }
}
