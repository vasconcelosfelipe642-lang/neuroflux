class AdminStatsModel {
  final int totalUsers;
  final int totalTasks;
  final int completedTasks;
  final int bannedUsers;

  const AdminStatsModel({
    required this.totalUsers,
    required this.totalTasks,
    required this.completedTasks,
    required this.bannedUsers,
  });
}

class UserTaskStatsModel {
  final int created;
  final int completed;

  const UserTaskStatsModel({required this.created, required this.completed});

  int get completionRatePercent =>
      created == 0 ? 0 : ((completed / created) * 100).round();
}
