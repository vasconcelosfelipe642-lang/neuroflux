import 'subtask_model.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isDaily;
  final List<SubtaskModel> subtasks;
  final DateTime createdAt;
  final String? usuarioId;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isDaily = false,
    this.subtasks = const [],
    required this.createdAt,
    this.usuarioId,
  });

  bool get hasSubtasks => subtasks.isNotEmpty;
  int get completedSubtasks => subtasks.where((s) => s.isCompleted).length;

  bool get canComplete =>
      subtasks.isEmpty || subtasks.every((s) => s.isCompleted);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subtarefas'] as List<dynamic>? ?? [];
    return TaskModel(
      id: json['id'].toString(),
      title: json['titulo'] as String,
      description: json['descricao'] as String?,
      isCompleted: json['concluida'] as bool? ?? false,
      isDaily: json['is_diaria'] as bool? ?? false,
      subtasks: rawSubs
          .map((s) => SubtaskModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      usuarioId: json['usuarioId']?.toString(),
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'titulo': title,
        'descricao': description,
        'is_diaria': isDaily,
      };

  Map<String, dynamic> toUpdateJson() => {
        'titulo': title,
        'descricao': description,
        'concluida': isCompleted,
        'is_diaria': isDaily,
      };

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isDaily,
    List<SubtaskModel>? subtasks,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isDaily: isDaily ?? this.isDaily,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
