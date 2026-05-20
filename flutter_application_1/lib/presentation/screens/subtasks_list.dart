import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';

class SubtasksList extends StatelessWidget {
  final TaskModel parentTask;
  final List<SubtaskModel> subtasks;
  final void Function(SubtaskModel) onToggleSubtask;
  final void Function(SubtaskModel) onEditSubtask;

  const SubtasksList({
    super.key,
    required this.parentTask,
    required this.subtasks,
    required this.onToggleSubtask,
    required this.onEditSubtask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 16),
      child: Column(
        children: subtasks.map((s) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              InkWell(onTap: () => onToggleSubtask(s), child: Icon(s.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: s.isCompleted ? AppColors.primary : AppColors.textHint)),
              const SizedBox(width: AppSizes.sm),
              Expanded(child: InkWell(onTap: () => onToggleSubtask(s), child: Text(s.title, style: TextStyle(fontSize: 13, color: s.isCompleted ? AppColors.textSecondary : AppColors.textPrimary, decoration: s.isCompleted ? TextDecoration.lineThrough : null)))),
              IconButton(icon: Icon(Icons.edit, size: 16, color: AppColors.textHint), onPressed: () => onEditSubtask(s), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
