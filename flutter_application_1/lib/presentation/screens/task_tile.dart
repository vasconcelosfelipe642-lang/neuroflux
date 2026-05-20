import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';
import 'subtasks_list.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final void Function(SubtaskModel) onToggleSubtask;
  final VoidCallback onEdit;
  final void Function(SubtaskModel) onEditSubtask;
  final VoidCallback onAddSubtask;
  final VoidCallback onDelete;
  final VoidCallback onOpenPomodoro;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onToggleSubtask,
    required this.onEdit,
    required this.onEditSubtask,
    required this.onAddSubtask,
    required this.onDelete,
    required this.onOpenPomodoro,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => onToggle(),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? AppColors.textHint : AppColors.textPrimary,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.timer_outlined, size: 20, color: AppColors.primary),
                      onPressed: onOpenPomodoro,
                      tooltip: 'Timer Pomodoro',
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(icon: const Icon(Icons.add_task, size: 20, color: AppColors.primary), onPressed: onAddSubtask, constraints: const BoxConstraints()),
                    IconButton(icon: Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary), onPressed: onEdit, constraints: const BoxConstraints()),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent), onPressed: onDelete, constraints: const BoxConstraints()),
                  ],
                ),
              ],
            ),
          ),
          if (task.hasSubtasks)
            SubtasksList(
              parentTask: task,
              subtasks: task.subtasks,
              onToggleSubtask: onToggleSubtask,
              onEditSubtask: onEditSubtask,
            ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    )
        .animate(target: task.isCompleted ? 1 : 0)
        .scale(
          begin: const Offset(0.97, 0.97),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        )
        .fade(
          begin: 0.88,
          end: 1,
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }
}
