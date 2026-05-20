import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class DayProgressCard extends StatefulWidget {
  final int completedTasks;
  final int totalTasks;
  final VoidCallback? onDayCompleted;

  const DayProgressCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    this.onDayCompleted,
  });

  @override
  State<DayProgressCard> createState() => _DayProgressCardState();
}

class _DayProgressCardState extends State<DayProgressCard> {
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
          const _CardHeader(),
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
          _GradientProgressBar(progress: _progress),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.track_changes_rounded,
          color: Colors.white,
          size: AppSizes.iconMd,
        ),
        const SizedBox(width: AppSizes.sm),
        Text(AppStrings.dayProgress, style: AppTextStyles.bigCardTitle),
      ],
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double progress;

  const _GradientProgressBar({required this.progress});

  static const _trackColor = Color(0x4DFFFFFF);
  static const _gradientStart = Color(0xFFFFB347);
  static const _gradientEnd = Colors.white;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          child: SizedBox(
            height: AppSizes.progressBarHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: _trackColor),
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [_gradientStart, _gradientEnd],
                    ).createShader(bounds),
                    child: const ColoredBox(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
