import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  static const _weekdayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekdayIndex = today.weekday - 1;
    final monday = today.subtract(Duration(days: weekdayIndex));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sua Semana', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: List.generate(7, (index) {
              final day = monday.add(Duration(days: index));
              final isToday = day == today;
              return Expanded(
                child: _DayItem(
                  label: _weekdayLabels[index],
                  dayNumber: day.day,
                  isToday: isToday,
                ),
              );
            }),
          ),
        ),
      ],
    )
        .animate()
        .slideY(begin: 0.08, end: 0, duration: 400.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 400.ms);
  }
}

class _DayItem extends StatelessWidget {
  final String label;
  final int dayNumber;
  final bool isToday;

  const _DayItem({
    required this.label,
    required this.dayNumber,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : AppColors.divider,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isToday ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          '$dayNumber',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
