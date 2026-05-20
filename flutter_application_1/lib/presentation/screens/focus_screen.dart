import 'package:flutter/material.dart';

import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';
import 'focus_screen_state.dart';

class FocusScreen extends StatefulWidget {
  final List<TaskModel> pendingTasks;
  final Future<void> Function(TaskModel task) onToggleTask;
  final Future<TaskModel> Function(TaskModel task, SubtaskModel subtask)
      onToggleSubtask;

  const FocusScreen({
    super.key,
    required this.pendingTasks,
    required this.onToggleTask,
    required this.onToggleSubtask,
  });

  @override
  State<FocusScreen> createState() => FocusScreenState();
}
