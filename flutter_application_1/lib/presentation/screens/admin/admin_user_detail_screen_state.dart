import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_rebuild.dart';
import '../../../core/theme/theme_scope.dart';
import '../../../core/utils/avatar_color.dart';
import '../../../data/services/admin_service.dart';
import '../../../domain/models/task_model.dart';
import '../../../domain/models/user_model.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/ban_user_dialog.dart';
import '../../widgets/admin/promote_user_dialog.dart';
import 'admin_activity_row.dart';
import 'admin_stat_box.dart';
import 'admin_user_detail_screen.dart';

class AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
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

  Future<void> _confirmPromote() async {
    final user = _user;
    if (user == null || user.isAdmin) return;

    final confirmed = await PromoteUserDialog.show(context, user: user);

    if (confirmed != true || !mounted) return;

    try {
      final updated = await _adminService.promoverParaAdmin(user);
      if (!mounted) return;
      setState(() => _user = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminPromoteSuccess)),
      );
    } on AppException catch (e) {
      _showError(e.message);
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
    ThemeScope.watch(context);

    return ThemeRebuild(
      builder: (context) {
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
      },
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
                const Text(
                  '● ${AppStrings.adminActive}',
                  style: AppTextStyles.adminStatusActive,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        Row(
          children: [
            Expanded(
              child: AdminStatBox(
                value: '${stats.created}',
                label: AppStrings.adminTasksCreatedLabel,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: AdminStatBox(
                value: '${stats.completed}',
                label: AppStrings.adminTasksCompletedLabel,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: AdminStatBox(
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
              ? Text('Nenhuma tarefa registrada.',
                  style: AppTextStyles.adminUserMeta)
              : Column(
                  children: _tasks.take(10).map((t) => AdminActivityRow(t)).toList(),
                ),
        ),
        const SizedBox(height: AppSizes.xxl),
        if (!user.isAdmin) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _confirmPromote,
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
              label: const Text(AppStrings.adminPromoteToAdmin),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: user.isAdmin ? null : _confirmBan,
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
