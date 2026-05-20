import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminUserTileAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final bool muted;

  const AdminUserTileAvatar({
    super.key,
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
