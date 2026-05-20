import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

class ProgressBigCardHeader extends StatelessWidget {
  const ProgressBigCardHeader({super.key});

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
