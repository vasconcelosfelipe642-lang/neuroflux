import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NewTaskModalHeader extends StatelessWidget {
  final VoidCallback onClose;

  const NewTaskModalHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.modalTitle, style: AppTextStyles.modalTitle),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: AppSizes.iconMd),
          color: AppColors.textSecondary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
