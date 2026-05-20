import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';
import 'day_progress_card.dart';
import 'day_progress_card_header.dart';
import 'gradient_progress_bar.dart';

class DayProgressCardState extends State<DayProgressCard> {
  bool _wasComplete = false;

  double get _progress =>
      widget.totalTasks == 0 ? 0 : widget.completedTasks / widget.totalTasks;

  bool get _isComplete =>
      widget.totalTasks > 0 &&
      widget.completedTasks == widget.totalTasks;

  String get _percentLabel =>
      '${(_progress * 100).toStringAsFixed(0)}%';

  @override
  void initState() {
    super.initState();
    _wasComplete = _isComplete;
  }

  @override
  void didUpdateWidget(DayProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isComplete && !_wasComplete) {
      widget.onDayCompleted?.call();
    }
    _wasComplete = _isComplete;
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DayProgressCardHeader(),
          const SizedBox(height: AppSizes.sm),
          Text(_percentLabel, style: AppTextStyles.bigPercent),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.tasksCompleted(
              widget.completedTasks,
              widget.totalTasks,
            ),
            style: AppTextStyles.bigCardSub,
          ),
          const SizedBox(height: AppSizes.md),
          GradientProgressBar(progress: _progress),
        ],
      ),
    );
  }
}
