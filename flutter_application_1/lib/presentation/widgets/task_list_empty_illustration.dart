import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class TaskListEmptyIllustration extends StatelessWidget {
  const TaskListEmptyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.primaryLightTint,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.checklist_rounded,
        size: 44,
        color: AppColors.primary,
      ),
    );
  }
}
