class SubtaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  const SubtaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubtaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
