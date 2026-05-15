import 'subtask_model.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final List<SubtaskModel> subtasks;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.subtasks = const [],
    required this.createdAt,
  });

  bool get hasSubtasks => subtasks.isNotEmpty;
  int get completedSubtasks => subtasks.where((s) => s.isCompleted).length;
  
  bool get canComplete => subtasks.isEmpty || subtasks.every((s) => s.isCompleted);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subtarefas'] as List<dynamic>? ?? [];
    return TaskModel(
      id: json['id'].toString(),
      title: json['titulo'] as String,
      description: json['descricao'] as String?,
      isCompleted: json['concluida'] as bool? ?? false,
      subtasks: rawSubs
          .map((s) => SubtaskModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'titulo': title,
        'descricao': description,
      };

  Map<String, dynamic> toUpdateJson() => {
        'titulo': title,
        'descricao': description,
        'concluida': isCompleted,
      };

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    List<SubtaskModel>? subtasks,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}