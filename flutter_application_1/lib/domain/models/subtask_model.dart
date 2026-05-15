class SubtaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  const SubtaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Mapeia o JSON do backend → campos: id, titulo, concluida
  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'].toString(),
      title: json['titulo'] as String,
      isCompleted: json['concluida'] as bool? ?? false,
    );
  }

  /// Mapeia para JSON → usado no PUT /subtarefas/:id
  Map<String, dynamic> toJson() => {
        'titulo': title,
        'concluida': isCompleted,
      };

  SubtaskModel copyWith({String? id, String? title, bool? isCompleted}) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
