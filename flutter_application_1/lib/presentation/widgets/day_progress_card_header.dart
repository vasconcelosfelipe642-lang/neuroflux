import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

class DayProgressCardHeader extends StatelessWidget {
  const DayProgressCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.track_changes_rounded,
          color: Colors.white,
          size: AppSizes.iconMd,
        ),
        SizedBox(width: AppSizes.sm),
        Text(AppStrings.dayProgress, style: AppTextStyles.bigCardTitle),
      ],
    );
  }
}
