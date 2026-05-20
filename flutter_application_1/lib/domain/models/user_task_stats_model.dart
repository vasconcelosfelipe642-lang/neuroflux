class UserTaskStatsModel {
  final int created;
  final int completed;

  const UserTaskStatsModel({required this.created, required this.completed});

  int get completionRatePercent =>
      created == 0 ? 0 : ((completed / created) * 100).round();
}
