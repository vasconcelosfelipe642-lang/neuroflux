import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';

class AdminHeaderAvatar extends StatelessWidget {
  final String initials;

  const AdminHeaderAvatar({super.key, required this.initials});

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
