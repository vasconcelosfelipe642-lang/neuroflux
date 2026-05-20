import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/time_ago.dart';
import '../../../domain/models/task_model.dart';

class AdminActivityRow extends StatelessWidget {
  final TaskModel task;

  const AdminActivityRow(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    final statusLabel = task.isCompleted
        ? AppStrings.adminTaskCompleted
        : AppStrings.adminTaskInProgress;
    final statusColor =
        task.isCompleted ? AppColors.successLight : AppColors.infoLight;
    final statusTextColor =
        task.isCompleted ? AppColors.success : AppColors.info;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: AppTextStyles.adminUserName),
                const SizedBox(height: 2),
                Text(TimeAgo.format(task.createdAt),
                    style: AppTextStyles.adminUserMeta),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
