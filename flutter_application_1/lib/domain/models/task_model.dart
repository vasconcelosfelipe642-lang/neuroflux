import 'subtask_model.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final List<SubtaskModel> subtasks;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.subtasks = const [],
    required this.createdAt,
  });

  bool get hasSubtasks => subtasks.isNotEmpty;

  int get completedSubtasks =>
      subtasks.where((s) => s.isCompleted).length;

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    List<SubtaskModel>? subtasks,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
