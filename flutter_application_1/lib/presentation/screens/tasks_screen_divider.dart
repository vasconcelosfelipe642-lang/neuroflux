import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';

class TasksScreenDivider extends StatelessWidget {
  const TasksScreenDivider({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(AppSizes.xl, 0, AppSizes.xl, AppSizes.md),
      child: Divider(color: AppColors.border, height: 1),
    );
  }
}
