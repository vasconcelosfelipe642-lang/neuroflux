import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_scope.dart';
import '../../../domain/models/user_model.dart';
import '../theme_toggle_button.dart';
import 'admin_header_avatar.dart';
import 'admin_header_badge.dart';

class AdminHeader extends StatelessWidget {
  final UserModel admin;
  final Future<void> Function() onLogout;
  final bool exclusiveLabel;
  final bool showBack;
  final VoidCallback? onBack;

  const AdminHeader({
    super.key,
    required this.admin,
    required this.onLogout,
    this.exclusiveLabel = false,
    this.showBack = false,
    this.onBack,
  });

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        ThemeScope.watch(modalContext);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: AppColors.textPrimary),
                title: Text(admin.nome, style: AppTextStyles.fieldLabel),
              ),
              Divider(color: AppColors.border),
              ListTile(
                onTap: () async {
                  Navigator.pop(modalContext);
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.popUntil((route) => route.isFirst);
                  }
                  await onLogout();
                },
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Sair do Aplicativo',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.pagePadding,
        AppSizes.md,
        AppSizes.pagePadding,
        AppSizes.lg,
      ),
      child: Row(
        children: [
          if (showBack) ...[
            IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            const SizedBox(width: AppSizes.xs),
          ],
          GestureDetector(
            onTap: () => _showProfileModal(context),
            child: AdminHeaderAvatar(initials: admin.initials),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exclusiveLabel
                      ? AppStrings.adminExclusiveLabel
                      : AppStrings.adminPanelLabel,
                  style: AppTextStyles.adminPanelLabel,
                ),
                Text(AppStrings.adminRoleTitle, style: AppTextStyles.adminTitle),
              ],
            ),
          ),
          const ThemeToggleButton(),
          const SizedBox(width: AppSizes.sm),
          const AdminHeaderBadge(label: AppStrings.adminBadge),
        ],
      ),
    );
  }
}
