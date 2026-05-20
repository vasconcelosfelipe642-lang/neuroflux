import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_scope.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/avatar_color.dart';
import '../../../domain/models/user_model.dart';

class AdminUserTile extends StatelessWidget {
  final UserModel user;
  final String subtitle;
  final bool isBanned;
  final VoidCallback? onTap;
  final VoidCallback? onBan;

  const AdminUserTile({
    super.key,
    required this.user,
    required this.subtitle,
    this.isBanned = false,
    this.onTap,
    this.onBan,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    final avatarColor =
        isBanned ? AppColors.mutedText : AvatarColor.forInitials(user.initials);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBanned ? null : onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
          child: Row(
            children: [
              _UserAvatar(
                initials: user.initials,
                color: avatarColor,
                muted: isBanned,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nome,
                      style: AppTextStyles.adminUserName.copyWith(
                        color: isBanned
                            ? AppColors.mutedText
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.adminUserMeta),
                  ],
                ),
              ),
              if (isBanned)
                _BannedChip()
              else if (onBan != null)
                _BanButton(onTap: onBan!),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final bool muted;

  const _UserAvatar({
    required this.initials,
    required this.color,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: muted ? AppColors.muted : color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.avatarForeground,
        ),
      ),
    );
  }
}

class _BanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.dangerLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Text(AppStrings.adminBan, style: AppTextStyles.adminDangerButton),
      ),
    );
  }
}

class _BannedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(AppStrings.adminBanned, style: AppTextStyles.adminStatusBanned),
    );
  }
}
