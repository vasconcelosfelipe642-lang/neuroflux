import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/models/user_model.dart';

class AppHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onLogout;

  const AppHeader({super.key, required this.user, required this.onLogout});

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
        ),
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: AppSizes.lg),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.textPrimary),
              title: Text(user.nome, style: AppTextStyles.fieldLabel),
            ),
            const Divider(color: AppColors.border),
            ListTile(
              onTap: () {
                Navigator.pop(modalContext);
                onLogout();
              },
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Sair do Aplicativo",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.xl, AppSizes.md, AppSizes.xl, AppSizes.lg,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProfileModal(context),
            child: _Avatar(initials: user.initials),
          ),
          const SizedBox(width: AppSizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.greeting, style: AppTextStyles.greetingSmall),
              const SizedBox(height: 2),
              Text(user.nome, style: AppTextStyles.greetingName),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarSize,
      height: AppSizes.avatarSize,
      decoration: const BoxDecoration(
        color: AppColors.avatarBackground,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.avatarForeground,
        ),
      ),
    );
  }
}