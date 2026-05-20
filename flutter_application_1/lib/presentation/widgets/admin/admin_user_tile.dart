import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_scope.dart';
import '../../../core/utils/avatar_color.dart';
import '../../../domain/models/user_model.dart';
import 'admin_ban_button.dart';
import 'admin_banned_chip.dart';
import 'admin_user_tile_avatar.dart';

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
              AdminUserTileAvatar(
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
                const AdminBannedChip()
              else if (onBan != null)
                AdminBanButton(onTap: onBan!),
            ],
          ),
        ),
      ),
    );
  }
}
