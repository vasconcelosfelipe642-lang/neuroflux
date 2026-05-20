import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';

class WeeklyDayItem extends StatelessWidget {
  final String label;
  final int dayNumber;
  final bool isToday;

  const WeeklyDayItem({
    super.key,
    required this.label,
    required this.dayNumber,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

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
