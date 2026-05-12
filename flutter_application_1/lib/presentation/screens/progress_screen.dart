import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/models/task_model.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_big_card.dart';
// StatCard está definido em progress_big_card.dart

class ProgressScreen extends StatelessWidget {
  /// Recebe as tarefas do dia — virá do provider/bloc futuramente
  final List<TaskModel> tasks;

  const ProgressScreen({super.key, required this.tasks});

  int get _completedCount => tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => tasks.where((t) => !t.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.pagePadding),
                child: Column(
                  children: [
                    ProgressBigCard(
                      completedTasks: _completedCount,
                      totalTasks: tasks.length,
                    ),
                    const SizedBox(height: AppSizes.md),
                    _StatsRow(
                      completedCount: _completedCount,
                      pendingCount: _pendingCount,
                    ),
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

class _StatsRow extends StatelessWidget {
  final int completedCount;
  final int pendingCount;

  const _StatsRow({
    required this.completedCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.trending_up_rounded,
            count: completedCount,
            label: AppStrings.tasksComplete,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: StatCard(
            icon: Icons.calendar_today_outlined,
            count: pendingCount,
            label: AppStrings.tasksPending,
          ),
        ),
      ],
    );
  }
}
