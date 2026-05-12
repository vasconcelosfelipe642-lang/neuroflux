import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/subtask_model.dart';
import '../widgets/app_header.dart';
import '../widgets/day_progress_card.dart';
import '../widgets/task_list_empty.dart';
import '../widgets/new_task_modal.dart';

class TasksScreen extends StatefulWidget {
  final List<TaskModel> tasks;
  final ValueChanged<List<TaskModel>> onTasksChanged;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> get _tasks => widget.tasks;

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  void _openNewTaskModal() {
    NewTaskModal.show(
      context,
      onAddTask: ({required String title, required List<SubtaskModel> subtasks}) {
        final updated = List<TaskModel>.from(_tasks)
          ..add(TaskModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
            subtasks: subtasks,
            createdAt: DateTime.now(),
          ));
        widget.onTasksChanged(updated);
      },
    );
  }

  void _toggleTask(String id) {
    final updated = _tasks.map((t) {
      if (t.id != id) return t;
      return t.copyWith(isCompleted: !t.isCompleted);
    }).toList();
    widget.onTasksChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            _DateLabel(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DayProgressCard(
                      completedTasks: _completedCount,
                      totalTasks: _tasks.length,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Text(AppStrings.today, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSizes.md),
                    _tasks.isEmpty
                        ? const TaskListEmpty()
                        : _TaskList(tasks: _tasks, onToggle: _toggleTask),
                    const SizedBox(height: AppSizes.xl),
                    _NewTaskButton(onPressed: _openNewTaskModal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.xl, 0, AppSizes.xl, AppSizes.md,
      ),
      child: const Divider(color: AppColors.border, height: 1),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<String> onToggle;

  const _TaskList({required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (_, index) => _TaskTile(
        task: tasks[index],
        onToggle: () => onToggle(tasks[index].id),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const _TaskTile({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (_) => onToggle(),
        activeColor: AppColors.primary,
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textSecondary,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      ),
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewTaskButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(AppStrings.newTask, style: AppTextStyles.fabLabel),
    );
  }
}
