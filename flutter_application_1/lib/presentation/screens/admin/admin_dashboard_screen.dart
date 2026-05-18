import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/services/admin_service.dart';
import '../../../domain/models/admin_stats_model.dart';
import '../../../domain/models/task_model.dart';
import '../../../domain/models/user_model.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/admin_stat_card.dart';
import '../../widgets/admin/admin_user_tile.dart';
import '../../widgets/admin/ban_user_dialog.dart';
import 'admin_user_detail_screen.dart';
import 'admin_users_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserModel admin;
  final VoidCallback onLogout;

  const AdminDashboardScreen({
    super.key,
    required this.admin,
    required this.onLogout,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _adminService = AdminService.instance;

  AdminStatsModel? _stats;
  List<UserModel> _users = [];
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _adminService.buscarEstatisticas(),
        _adminService.listarUsuarios(),
        _adminService.listarTodasTarefas(),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as AdminStatsModel;
        _users = results[1] as List<UserModel>;
        _tasks = results[2] as List<TaskModel>;
        _isLoading = false;
      });
    } on AppException catch (e) {
      _showError(e.message);
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  int _taskCountFor(String userId) =>
      _tasks.where((t) => t.usuarioId == userId).length;

  Future<void> _openUsers() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminUsersScreen(
          admin: widget.admin,
          onLogout: widget.onLogout,
        ),
      ),
    );
    _load();
  }

  Future<void> _openUserDetail(UserModel user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminUserDetailScreen(
          admin: widget.admin,
          userId: user.id,
          onLogout: widget.onLogout,
          onBanned: _load,
        ),
      ),
    );
    _load();
  }

  Future<void> _confirmBan(UserModel user) async {
    final confirmed = await BanUserDialog.show(context, user: user);
    if (confirmed != true || !mounted) return;
    try {
      await _adminService.banirUsuario(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminBanSuccess)),
      );
      _load();
    } on AppException catch (e) {
      _showError(e.message);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: AppSizes.xxl),
                  children: [
                    AdminHeader(
                      admin: widget.admin,
                      onLogout: widget.onLogout,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.pagePadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.adminOverview,
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: AppSizes.md),
                          _buildStatsGrid(),
                          const SizedBox(height: AppSizes.xxl),
                          _buildRecentUsersHeader(),
                          const SizedBox(height: AppSizes.md),
                          _buildRecentUsersList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = _stats!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSizes.md,
      crossAxisSpacing: AppSizes.md,
      childAspectRatio: 1.15,
      children: [
        AdminStatCard(
          icon: Icons.people_outline,
          iconColor: AppColors.info,
          iconBackground: AppColors.infoLight,
          value: '${stats.totalUsers}',
          label: AppStrings.adminRegisteredUsers(stats.totalUsers),
        ),
        AdminStatCard(
          icon: Icons.description_outlined,
          iconColor: AppColors.textSecondary,
          iconBackground: AppColors.muted,
          value: '${stats.totalTasks}',
          label: AppStrings.adminTasksCreated(stats.totalTasks),
        ),
        AdminStatCard(
          icon: Icons.check_box_outlined,
          iconColor: AppColors.success,
          iconBackground: AppColors.successLight,
          value: '${stats.completedTasks}',
          label: AppStrings.adminTasksCompleted(stats.completedTasks),
        ),
        AdminStatCard(
          icon: Icons.block,
          iconColor: AppColors.danger,
          iconBackground: AppColors.dangerLight,
          value: '${stats.bannedUsers}',
          label: AppStrings.adminBannedUsers(stats.bannedUsers),
        ),
      ],
    );
  }

  Widget _buildRecentUsersHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.adminRecentUsers, style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Text(AppStrings.adminManageUsers, style: AppTextStyles.cardLabel),
            const Spacer(),
            GestureDetector(
              onTap: _openUsers,
              child: Text(AppStrings.adminSeeAll, style: AppTextStyles.adminLink),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentUsersList() {
    final recent = _users
        .where((u) => u.id != widget.admin.id && u.role != 'admin')
        .take(5)
        .toList();

    if (recent.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.xl),
        child: Center(child: Text(AppStrings.noTasksTitle)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: recent.map((user) {
          final tasks = _taskCountFor(user.id);
          return AdminUserTile(
            key: ValueKey(user.id),
            user: user,
            subtitle: AppStrings.adminUserSubtitle(tasks),
            onTap: () => _openUserDetail(user),
            onBan: () => _confirmBan(user),
          );
        }).toList(),
      ),
    );
  }
}
