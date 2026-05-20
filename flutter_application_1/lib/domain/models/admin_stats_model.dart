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
