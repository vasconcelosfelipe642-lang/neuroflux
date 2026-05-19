import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/avatar_color.dart';
import '../../../core/utils/time_ago.dart';
import '../../../data/services/admin_service.dart';
import '../../../domain/models/task_model.dart';
import '../../../domain/models/user_model.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/ban_user_dialog.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final UserModel admin;
  final String userId;
  final Future<void> Function() onLogout;
  final VoidCallback? onBanned;

  const AdminUserDetailScreen({
    super.key,
    required this.admin,
    required this.userId,
    required this.onLogout,
    this.onBanned,
  });

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final _adminService = AdminService.instance;

  UserModel? _user;
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
      final user = await _adminService.buscarUsuario(widget.userId);
      final allTasks = await _adminService.listarTodasTarefas();
      if (!mounted) return;
      setState(() {
        _user = user;
        _tasks = _adminService.tarefasDoUsuario(allTasks, widget.userId)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _isLoading = false;
      });
    } on AppException catch (e) {
      _showError(e.message);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmBan() async {
    final user = _user;
    if (user == null) return;
    final confirmed = await BanUserDialog.show(context, user: user);
    if (confirmed != true || !mounted) return;
    try {
      await _adminService.banirUsuario(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminBanSuccess)),
      );
      widget.onBanned?.call();
      Navigator.pop(context);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              admin: widget.admin,
              onLogout: widget.onLogout,
              showBack: true,
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
              child: Text(
                AppStrings.adminManageUsers,
                style: AppTextStyles.adminScreenTitle,
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final user = _user!;
    final stats = _adminService.statsDoUsuario(_tasks);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.pagePadding,
        AppSizes.md,
        AppSizes.pagePadding,
        AppSizes.xxl,
      ),
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AvatarColor.forInitials(user.initials),
              child: Text(
                user.initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.avatarForeground,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(user.nome, style: AppTextStyles.adminScreenTitle.copyWith(fontSize: 20)),
            if (user.email.isNotEmpty) ...[
              const SizedBox(height: AppSizes.xs),
              Text(user.email, style: AppTextStyles.adminUserMeta),
            ],
            const SizedBox(height: AppSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('● ${AppStrings.adminActive}',
                    style: AppTextStyles.adminStatusActive),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                value: '${stats.created}',
                label: AppStrings.adminTasksCreatedLabel,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _StatBox(
                value: '${stats.completed}',
                label: AppStrings.adminTasksCompletedLabel,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _StatBox(
                value: '${stats.completionRatePercent}%',
                label: AppStrings.adminCompletionRateLabel,
                highlight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        Text(AppStrings.adminRecentActivity, style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.md),
        Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: _tasks.isEmpty
              ? const Text('Nenhuma tarefa registrada.',
                  style: AppTextStyles.adminUserMeta)
              : Column(
                  children: _tasks.take(10).map(_ActivityRow.new).toList(),
                ),
        ),
        const SizedBox(height: AppSizes.xxl),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: _confirmBan,
            icon: const Icon(Icons.block, color: AppColors.dangerDark, size: 18),
            label: Text(AppStrings.adminBanThisUser,
                style: AppTextStyles.adminDangerButton.copyWith(fontSize: 15)),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.dangerLight,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const _StatBox({
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg, horizontal: AppSizes.sm),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: highlight
                ? AppTextStyles.adminHighlightPercent
                : AppTextStyles.adminStatNumber.copyWith(fontSize: 22),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.adminStatLabel,
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final TaskModel task;
  const _ActivityRow(this.task);

  @override
  Widget build(BuildContext context) {
    final statusLabel = task.isCompleted
        ? AppStrings.adminTaskCompleted
        : AppStrings.adminTaskInProgress;
    final statusColor =
        task.isCompleted ? AppColors.successLight : AppColors.infoLight;
    final statusTextColor =
        task.isCompleted ? AppColors.success : AppColors.info;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: AppTextStyles.adminUserName),
                const SizedBox(height: 2),
                Text(TimeAgo.format(task.createdAt),
                    style: AppTextStyles.adminUserMeta),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
