import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

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
          _CardHeader(),
          const SizedBox(height: AppSizes.sm),
          Text(_percentLabel, style: AppTextStyles.bigPercent),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.tasksCompleted(completedTasks, totalTasks),
            style: AppTextStyles.bigCardSub,
          ),
          const SizedBox(height: AppSizes.md),
          _ProgressBar(progress: _progress),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.track_changes_rounded, color: Colors.white, size: AppSizes.iconMd),
        const SizedBox(width: AppSizes.sm),
        Text(AppStrings.dayProgress, style: AppTextStyles.bigCardTitle),
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
        backgroundColor: Colors.white30,
        valueColor: const AlwaysStoppedAnimation(Colors.white60),
      ),
    );
  }
}

/// Card de métrica genérico reutilizável
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
