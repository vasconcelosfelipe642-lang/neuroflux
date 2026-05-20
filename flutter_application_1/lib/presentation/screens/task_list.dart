import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';
import '../widgets/pomodoro_timer.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onToggle;
  final void Function(TaskModel, SubtaskModel) onToggleSubtask;
  final ValueChanged<TaskModel> onEdit;
  final void Function(TaskModel, SubtaskModel) onEditSubtask;
  final ValueChanged<TaskModel> onAddSubtask;
  final ValueChanged<TaskModel> onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onToggleSubtask,
    required this.onEdit,
    required this.onEditSubtask,
    required this.onAddSubtask,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (_, i) => TaskTile(
        task: tasks[i],
        onToggle: () => onToggle(tasks[i]),
        onToggleSubtask: (sub) => onToggleSubtask(tasks[i], sub),
        onEdit: () => onEdit(tasks[i]),
        onEditSubtask: (sub) => onEditSubtask(tasks[i], sub),
        onAddSubtask: () => onAddSubtask(tasks[i]),
        onDelete: () => onDelete(tasks[i]),
        onOpenPomodoro: () => PomodoroTimerSheet.show(
          context,
          taskTitle: tasks[i].title,
        ),
      ),
    );
  }
}
