import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_scope.dart';
import '../../../data/services/admin_service.dart';
import '../../../domain/models/task_model.dart';
import '../../../domain/models/user_model.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/admin_user_tile.dart';
import '../../widgets/admin/ban_user_dialog.dart';
import 'admin_user_detail_screen.dart';
import 'admin_user_section.dart';
import 'admin_users_screen.dart';

class AdminUsersScreenState extends State<AdminUsersScreen> {
  final _adminService = AdminService.instance;
  final _searchController = TextEditingController();

  List<UserModel> _activeUsers = [];
  List<UserModel> _bannedUsers = [];
  List<TaskModel> _tasks = [];
  String _query = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _adminService.listarUsuarios(),
        _adminService.listarBanidos(),
        _adminService.listarTodasTarefas(),
      ]);
      if (!mounted) return;
      final allUsers = results[0] as List<UserModel>;
      final banned = results[1] as List<UserModel>;
      setState(() {
        _bannedUsers = banned;
        _activeUsers = allUsers
            .where((u) =>
                u.id != widget.admin.id &&
                u.role != 'admin' &&
                !banned.any((b) => b.id == u.id))
            .toList();
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

  List<UserModel> _filter(List<UserModel> users) {
    if (_query.isEmpty) return users;
    return users
        .where((u) =>
            u.nome.toLowerCase().contains(_query) ||
            u.email.toLowerCase().contains(_query))
        .toList();
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
    ThemeScope.watch(context);

    final active = _filter(_activeUsers);
    final banned = _filter(_bannedUsers);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              admin: widget.admin,
              onLogout: widget.onLogout,
              exclusiveLabel: true,
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
            const SizedBox(height: AppSizes.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.adminSearchHint,
                  prefixIcon: Icon(Icons.search, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.pagePadding,
                          0,
                          AppSizes.pagePadding,
                          AppSizes.xxl,
                        ),
                        children: [
                          AdminUserSection(
                            title: AppStrings.adminActiveCount(active.length),
                            children: active.map((user) {
                              final tasks = _taskCountFor(user.id);
                              return AdminUserTile(
                                user: user,
                                subtitle:
                                    AppStrings.adminUserStatusActive(tasks),
                                onTap: () => _openUserDetail(user),
                                onBan: () => _confirmBan(user),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppSizes.lg),
                          AdminUserSection(
                            title: AppStrings.adminBannedCount(banned.length),
                            children: banned.map((user) {
                              return AdminUserTile(
                                user: user,
                                subtitle: AppStrings.adminUserStatusBanned(0),
                                isBanned: true,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
