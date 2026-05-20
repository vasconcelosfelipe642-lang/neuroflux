import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

class AppHeaderAvatar extends StatelessWidget {
  final String initials;
  final Color color;

  const AppHeaderAvatar({super.key, required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarSize,
      height: AppSizes.avatarSize,
      decoration: BoxDecoration(
        color: color,
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
